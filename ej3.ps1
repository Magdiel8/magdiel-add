# 1. COMPROBAR PARÁMETROS
if ($args.Count -ne 1) {
    Write-Host "Error: Faltan parametros. Uso: .\nombre03.ps1 bajas.txt"
    exit
}

$ficheroEntrada = $args[0]

if (-not (Test-Path $ficheroEntrada)) {
    Write-Host "Error: El fichero '$ficheroEntrada' no existe."
    exit
}

# 2. PREPARAR RUTAS (Se crean donde ejecutes el script)
if ($PSScriptRoot) {
    $carpetaActual = $PSScriptRoot
} else {
    $carpetaActual = (Get-Location).Path
}

Write-Host "--> Trabajando en: $carpetaActual"

$rutaLogs = "$carpetaActual\Logs"
$rutaBackup = "$carpetaActual\proyecto"

# Crear carpeta Logs si no existe
if (-not (Test-Path $rutaLogs)) { 
    New-Item -Path $rutaLogs -ItemType Directory | Out-Null 
}

$ficheroLogErrores = "$rutaLogs\bajaserror.log"
$ficheroLogBajas   = "$rutaLogs\bajas.log"

# Leer fichero de usuarios
$listaUsuarios = Get-Content $ficheroEntrada

# 3. PROCESAR CADA USUARIO
foreach ($linea in $listaUsuarios) {
    
    if ($linea -eq "") { continue }

    $partes = $linea.Split(':')

    if ($partes.Count -ne 4) { continue }

    $nombre    = $partes[0]
    $apellidos = "$($partes[1]) $($partes[2])"
    $login     = $partes[3]

    # Verificar si el usuario existe
    $usuario = Get-LocalUser -Name $login -ErrorAction SilentlyContinue

    if (-not $usuario) {
        # --- NO EXISTE: LOG DE ERROR ---
        $fecha = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
        $mensaje = "$fecha-$login-$nombre-$apellidos-El usuario no existe en el sistema"
        Add-Content -Path $ficheroLogErrores -Value $mensaje
        Write-Host "Usuario $login no encontrado."
    }
    else {
        # --- EXISTE: PROCESAR BAJA ---
        Write-Host "Procesando baja: $login"

        $carpetaUsuario = "C:\Users\$login"
        $carpetaTrabajo = "$carpetaUsuario\trabajo"
        $carpetaDestino = "$rutaBackup\$login"
        $listaFicherosMovidos = @()

        # Mover ficheros
        if (Test-Path $carpetaTrabajo) {
            if (-not (Test-Path $carpetaDestino)) {
                New-Item -Path $carpetaDestino -ItemType Directory -Force | Out-Null
            }
            $ficheros = Get-ChildItem -Path $carpetaTrabajo -File
            foreach ($fich in $ficheros) {
                Move-Item -Path $fich.FullName -Destination $carpetaDestino
                $listaFicherosMovidos += $fich
            }
        }

        # Escribir en bajas.log
        $fechaLog = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
        Add-Content -Path $ficheroLogBajas -Value "--------------------------------------------------"
        Add-Content -Path $ficheroLogBajas -Value "Fecha: $fechaLog | Usuario: $login"
        Add-Content -Path $ficheroLogBajas -Value "Carpeta destino: $carpetaDestino"
        
        $contador = 1
        foreach ($f in $listaFicherosMovidos) {
            Add-Content -Path $ficheroLogBajas -Value "$contador. $($f.Name)"
            $contador++
        }
        Add-Content -Path $ficheroLogBajas -Value "Total ficheros: $($listaFicherosMovidos.Count)"

        # Cambiar Propietario (Requiere Admin)
        try {
            foreach ($f in $listaFicherosMovidos) {
                $ruta = "$carpetaDestino\$($f.Name)"
                $acl = Get-Acl $ruta
                $acl.SetOwner([System.Security.Principal.NTAccount]"Administradores")
                Set-Acl $ruta $acl
            }
        } catch {
            Write-Host "Aviso: No se pudo cambiar propietario (Faltan permisos)."
        }

        # Borrar usuario y datos
        Remove-Item -Path $carpetaUsuario -Recurse -Force -ErrorAction SilentlyContinue
        Remove-LocalUser -Name $login
        Write-Host "Usuario $login eliminado."
    }
}
Write-Host "Fin."
