# ==============================================================================
# 1. COMPROBAR PARÁMETROS Y MODO DRY-RUN
# ==============================================================================

# Detectar si se ha pasado el flag --dry-run
$DryRun = $false
if ($args -contains "--dry-run") {
    $DryRun = $true
    Write-Host "************************************************"
    Write-Host "* MODO SIMULACIÓN (DRY-RUN) ACTIVADO           *"
    Write-Host "* No se realizarán cambios reales en el sistema*"
    Write-Host "************************************************"
}

# Filtrar los argumentos para quedarse solo con el nombre del fichero (quitamos --dry-run)
$argsLimpios = $args | Where-Object { $_ -ne "--dry-run" }

if ($argsLimpios.Count -ne 1) {
    Write-Host "Error: Faltan parametros."
    Write-Host "Uso: .\nombre03.ps1 bajas.txt [--dry-run]"
    exit
}

$ficheroEntrada = $argsLimpios[0]

# Comprobamos si existe el fichero de entrada (esto se comprueba incluso en dry-run)
if (-not (Test-Path $ficheroEntrada)) {
    Write-Host "Error: El fichero '$ficheroEntrada' no existe."
    exit
}

# ==============================================================================
# 2. PREPARAR RUTAS
# ==============================================================================
if ($PSScriptRoot) {
    $carpetaActual = $PSScriptRoot
} else {
    $carpetaActual = (Get-Location).Path
}

if (-not $DryRun) { Write-Host "--> Trabajando en: $carpetaActual" }

$rutaLogs = "$carpetaActual\Logs"
$rutaBackup = "$carpetaActual\proyecto"

# Crear carpeta Logs si no existe
if (-not (Test-Path $rutaLogs)) { 
    if ($DryRun) {
        Write-Host "[SIMULACRO] Se crearía la carpeta de Logs: $rutaLogs"
    } else {
        New-Item -Path $rutaLogs -ItemType Directory | Out-Null 
    }
}

$ficheroLogErrores = "$rutaLogs\bajaserror.log"
$ficheroLogBajas   = "$rutaLogs\bajas.log"

# Leer fichero de usuarios
$listaUsuarios = Get-Content $ficheroEntrada

# ==============================================================================
# 3. PROCESAR CADA USUARIO
# ==============================================================================
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
        
        if ($DryRun) {
            Write-Host "[SIMULACRO - ERROR LOG] Se escribiría en bajaserror.log: $mensaje"
        } else {
            Add-Content -Path $ficheroLogErrores -Value $mensaje
            Write-Host "Usuario $login no encontrado."
        }
    }
    else {
        # --- EXISTE: PROCESAR BAJA ---
        if ($DryRun) { Write-Host "`n[SIMULACRO] Procesando usuario: $login" }
        else { Write-Host "Procesando baja: $login" }

        $carpetaUsuario = "C:\Users\$login"
        $carpetaTrabajo = "$carpetaUsuario\trabajo"
        $carpetaDestino = "$rutaBackup\$login"
        $listaFicherosMovidos = @()

        # --- MOVER FICHEROS ---
        if (Test-Path $carpetaTrabajo) {
            # Crear carpeta destino
            if (-not (Test-Path $carpetaDestino)) {
                if ($DryRun) {
                    Write-Host "    [SIMULACRO] Se crearía carpeta backup: $carpetaDestino"
                } else {
                    New-Item -Path $carpetaDestino -ItemType Directory -Force | Out-Null
                }
            }
            
            # Obtener ficheros
            $ficheros = Get-ChildItem -Path $carpetaTrabajo -File
            foreach ($fich in $ficheros) {
                if ($DryRun) {
                    Write-Host "    [SIMULACRO] Se movería fichero: $($fich.Name) -> $carpetaDestino"
                    # Añadimos a la lista simulada para mostrar en el log simulado
                    $listaFicherosMovidos += $fich
                } else {
                    Move-Item -Path $fich.FullName -Destination $carpetaDestino
                    $listaFicherosMovidos += $fich
                }
            }
        } else {
            if ($DryRun) { Write-Host "    [SIMULACRO] No existe carpeta 'trabajo' para este usuario." }
        }

        # --- LOG DE BAJAS ---
        $fechaLog = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
        
        # Bloque de texto para el log
        $logBuffer = @()
        $logBuffer += "--------------------------------------------------"
        $logBuffer += "Fecha: $fechaLog | Usuario: $login"
        $logBuffer += "Carpeta destino: $carpetaDestino"
        
        $contador = 1
        foreach ($f in $listaFicherosMovidos) {
            $logBuffer += "$contador. $($f.Name)"
            $contador++
        }
        $logBuffer += "Total ficheros: $($listaFicherosMovidos.Count)"

        if ($DryRun) {
            Write-Host "    [SIMULACRO - LOG BAJAS] Se escribiría lo siguiente en bajas.log:"
            $logBuffer | ForEach-Object { Write-Host "        $_" }
        } else {
            Add-Content -Path $ficheroLogBajas -Value $logBuffer
        }

        # --- CAMBIAR PROPIETARIO ---
        if ($DryRun) {
             if ($listaFicherosMovidos.Count -gt 0) {
                Write-Host "    [SIMULACRO] Se cambiaría el propietario a 'Administradores' de $($listaFicherosMovidos.Count) ficheros."
             }
        } else {
            try {
                foreach ($f in $listaFicherosMovidos) {
                    $ruta = "$carpetaDestino\$($f.Name)"
                    # Pequeña comprobación por seguridad
                    if (Test-Path $ruta) {
                        $acl = Get-Acl $ruta
                        $acl.SetOwner([System.Security.Principal.NTAccount]"Administradores")
                        Set-Acl $ruta $acl
                    }
                }
            } catch {
                Write-Host "Aviso: No se pudo cambiar propietario (Faltan permisos)."
            }
        }

        # --- BORRAR USUARIO Y DATOS ---
        if ($DryRun) {
            Write-Host "    [SIMULACRO] Se borraría recursivamente la carpeta: $carpetaUsuario"
            Write-Host "    [SIMULACRO] Se eliminaría el usuario local: $login"
        } else {
            Remove-Item -Path $carpetaUsuario -Recurse -Force -ErrorAction SilentlyContinue
            Remove-LocalUser -Name $login
            Write-Host "Usuario $login eliminado."
        }
    }
}

Write-Host "Fin."
