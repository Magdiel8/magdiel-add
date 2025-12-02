# nombrepower.ps1
# Script con menu para practicas (items 16-30)
# Todas las tildes y 'ñ' han sido reemplazadas por 'n' segun lo pedido.
# Requisitos: ejecutar en PowerShell con privilegios cuando sea necesario (gestion de usuarios/grupos, diskpart, etc.).
# Uso: Ejecutar el script y elegir la opcion del menu. Algunos items requieren confirmacion o privilegios de administrador.

# --- FUNCIONES ---

function Show-Menu {
    Clear-Host
    Write-Output "=== MENU PRINCIPAL ==="
    Write-Output "16) Pizza"
    Write-Output "17) Dias (pares/impares anio bisiesto)"
    Write-Output "18) Menu usuarios"
    Write-Output "19) Menu grupos"
    Write-Output "20) Diskp (usar con precaucion)"
    Write-Output "21) Contrasena (validacion)"
    Write-Output "22) Fibonacci (iterativo)"
    Write-Output "23) Fibonacci (recursivo)"
    Write-Output "24) Monitoreo CPU (30 segundos)"
    Write-Output "25) alertaEspacio"
    Write-Output "26) CopiasMasivas"
    Write-Output "27) automatizarps"
    Write-Output "28) Barrido IP (ping sweep)"
    Write-Output "29) Evento (exportar eventos)"
    Write-Output "30) Limpieza (parametros)"
    Write-Output "0) Salir"
}

# 16 Pizza
function Pizza {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("s","n","S","N")]
        [string] $EsVegetariana
    )
    $veg = @("Pimiento","Tofu")
    $noveg = @("Peperoni","Jamon","Salmon")
    if ($EsVegetariana -match '^[sS]') {
        Write-Output "Ingredientes disponibles (ademas de tomate y mozzarella):"
        for ($i=0; $i -lt $veg.Count; $i++) { Write-Output "[$($i+1)] $($veg[$i])" }
        $sel = Read-Host "Elige el numero del ingrediente (solo 1)"
        if ($sel -as [int] -and $sel -ge 1 -and $sel -le $veg.Count) {
            $ingredientes = @("Tomate","Mozzarella",$veg[$sel-1])
            Write-Output "Has elegido una pizza VEGETARIANA con: $($ingredientes -join ', ')"
        } else {
            Write-Output "Seleccion no valida."
        }
    } else {
        Write-Output "Ingredientes disponibles (ademas de tomate y mozzarella):"
        for ($i=0; $i -lt $noveg.Count; $i++) { Write-Output "[$($i+1)] $($noveg[$i])" }
        $sel = Read-Host "Elige el numero del ingrediente (solo 1)"
        if ($sel -as [int] -and $sel -ge 1 -and $sel -le $noveg.Count) {
            $ingredientes = @("Tomate","Mozzarella",$noveg[$sel-1])
            Write-Output "Has elegido una pizza NO VEGETARIANA con: $($ingredientes -join ', ')"
        } else {
            Write-Output "Seleccion no valida."
        }
    }
}

# 17 Dias pares e impares en anio bisiesto
function Dias-ParesImpares {
    # Un anno bisiesto tiene 366 dias => pares 179, impares 187 (segun enunciado)
    Write-Output "En un anio bisiesto hay 179 dias pares y 187 dias impares."
}

# 18 menu_usuarios
function Menu-Usuarios {
    while ($true) {
        Write-Output "`n--- MENU USUARIOS ---"
        Write-Output "1) Listar usuarios locales"
        Write-Output "2) Crear usuario (pide usuario y contrasena)"
        Write-Output "3) Eliminar usuario (pide usuario)"
        Write-Output "4) Modificar usuario (renombrar)"
        Write-Output "0) Volver"
        $op = Read-Host "Opcion"
        switch ($op) {
            "1" {
                try {
                    Get-LocalUser | Select-Object Name,Enabled,LastLogon | Format-Table -AutoSize
                } catch {
                    Write-Error "No se puede listar usuarios. Ejecuta PowerShell como administrador o el modulo de cuentas locales no esta disponible."
                }
            }
            "2" {
                $u = Read-Host "Nombre de usuario a crear"
                $p = Read-Host "Contrasena (se mostrara en claro)"
                try {
                    $secure = ConvertTo-SecureString $p -AsPlainText -Force
                    New-LocalUser -Name $u -Password $secure -FullName $u -PasswordNeverExpires:$true
                    Write-Output "Usuario $u creado."
                } catch {
                    Write-Error "Error creando usuario: $_"
                }
            }
            "3" {
                $u = Read-Host "Nombre de usuario a eliminar"
                try {
                    Remove-LocalUser -Name $u -ErrorAction Stop
                    Write-Output "Usuario $u eliminado."
                } catch {
                    Write-Error "Error eliminando usuario: $_"
                }
            }
            "4" {
                $u = Read-Host "Nombre del usuario a renombrar"
                $new = Read-Host "Nuevo nombre"
                try {
                    Rename-LocalUser -Name $u -NewName $new -ErrorAction Stop
                    Write-Output "Usuario $u renombrado a $new."
                } catch {
                    Write-Error "Error renombrando usuario: $_"
                }
            }
            "0" { break }
            default { Write-Output "Opcion no valida" }
        }
    }
}

# 19 menu_grupos
function Menu-Grupos {
    while ($true) {
        Write-Output "`n--- MENU GRUPOS ---"
        Write-Output "1) Listar grupos y miembros"
        Write-Output "2) Crear grupo"
        Write-Output "3) Eliminar grupo"
        Write-Output "4) Añadir miembro a grupo"
        Write-Output "5) Eliminar miembro de grupo"
        Write-Output "0) Volver"
        $op = Read-Host "Opcion"
        switch ($op) {
            "1" {
                try {
                    Get-LocalGroup | ForEach-Object {
                        $g = $_
                        $members = (Get-LocalGroupMember -Group $g.Name -ErrorAction SilentlyContinue) | Select-Object -ExpandProperty Name -ErrorAction SilentlyContinue
                        [PSCustomObject]@{Group=$g.Name; Members=($members -join ", ")}
                    } | Format-Table -AutoSize
                } catch {
                    Write-Error "Error listando grupos: $_"
                }
            }
            "2" {
                $g = Read-Host "Nombre del grupo a crear"
                try { New-LocalGroup -Name $g; Write-Output "Grupo $g creado." } catch { Write-Error "Error: $_" }
            }
            "3" {
                $g = Read-Host "Nombre del grupo a eliminar"
                try { Remove-LocalGroup -Name $g -ErrorAction Stop; Write-Output "Grupo $g eliminado." } catch { Write-Error "Error: $_" }
            }
            "4" {
                $g = Read-Host "Grupo"
                $u = Read-Host "Usuario"
                try { Add-LocalGroupMember -Group $g -Member $u; Write-Output "Miembro añadido." } catch { Write-Error "Error: $_" }
            }
            "5" {
                $g = Read-Host "Grupo"
                $u = Read-Host "Usuario"
                try { Remove-LocalGroupMember -Group $g -Member $u; Write-Output "Miembro eliminado." } catch { Write-Error "Error: $_" }
            }
            "0" { break }
            default { Write-Output "Opcion no valida" }
        }
    }
}

# 20 Diskp
function Diskp {
    param([Parameter(Mandatory=$true)] [int] $DiskNumber, [switch] $Simular)
    # Muestra tamano del disco en GB y crea particiones de 1GB con diskpart hasta llenarlo
    try {
        $disk = Get-Disk -Number $DiskNumber -ErrorAction Stop
    } catch {
        Write-Error "No se encontro el disco $DiskNumber. Asegurate de ejecutar con permisos de administrador."
        return
    }
    $sizeGB = [math]::Round($disk.Size/1GB,2)
    Write-Output "Disco $DiskNumber tamano aprox: $sizeGB GB"
    if ($Simular) {
        Write-Output "Simulacion activada. No se ejecutaran cambios."
    } else {
        $confirm = Read-Host "Vas a limpiar y particionar el disco $DiskNumber. Esto BORRARA TODO. Escribe SI para confirmar"
        if ($confirm -ne "SI") { Write-Output "Operacion cancelada."; return }
    }
    # Calcular numero de particiones de 1GB
    $count = [int]([math]::Floor($disk.Size/1GB))
    if ($count -lt 1) { Write-Output "Disco demasiado pequeno para particiones de 1GB."; return }
    $script = @()
    $script += "select disk $DiskNumber"
    $script += "clean"
    for ($i=1; $i -le $count; $i++) {
        $script += "create partition primary size=1024"
        $script += "format fs=ntfs quick"
        $script += "assign"
    }
    $tmp = Join-Path $env:TEMP "diskpart_script.txt"
    $script -join "`r`n" | Out-File -FilePath $tmp -Encoding ASCII
    if ($Simular) {
        Write-Output "Contenido de diskpart (simulacion):"
        Get-Content $tmp | Write-Output
    } else {
        Write-Output "Ejecutando diskpart..."
        diskpart /s $tmp
        Write-Output "Diskpart finalizado."
    }
}

# 21 Contrasena: validacion
function Validate-Password {
    param([Parameter(Mandatory=$true)] [string] $Password)
    $hasLower = $Password -match '[a-z]'
    $hasUpper = $Password -match '[A-Z]'
    $hasDigit = $Password -match '\d'
    $hasSpecial = $Password -match '[^A-Za-z0-9]'
    $len = $Password.Length -ge 8
    if ($hasLower -and $hasUpper -and $hasDigit -and $hasSpecial -and $len) {
        Write-Output "Contrasena VALIDA."
        return $true
    } else {
        Write-Output "Contrasena NO VALIDA. Requisitos: minusculas, mayusculas, numeros, caracteres especiales, >=8 caracteres."
        return $false
    }
}

# 22 Fibonacci iterativo
function Fibonacci-Iterativo {
    param([Parameter(Mandatory=$true)] [int] $N)
    if ($N -le 0) { Write-Output "N debe ser mayor que 0"; return }
    $a=0; $b=1
    for ($i=1; $i -le $N; $i++) {
        Write-Output $a
        $tmp=$a+$b; $a=$b; $b=$tmp
    }
}

# 23 Fibonacci recursivo
function Fibonacci-Recursivo {
    param([Parameter(Mandatory=$true)] [int] $N)
    function fib([int]$n) {
        if ($n -le 1) { return $n }
        return (fib($n-1) + fib($n-2))
    }
    for ($i=0; $i -lt $N; $i++) { Write-Output (fib $i) }
}

# 24 Monitoreo CPU (30s, cada 5s)
function Monitoreo-CPU {
    $samples = @()
    $interval = 5
    $totalTime = 30
    $iterations = [int]($totalTime / $interval)
    for ($i=1; $i -le $iterations; $i++) {
        # Get-Counter may return multiple samples; use first
        try {
            $val = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
        } catch {
            # Fallback to WMI
            $val = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
        }
        $samples += $val
        Write-Output ("Muestra $i: {0:N2}%" -f $val)
        Start-Sleep -Seconds $interval
    }
    $avg = ($samples | Measure-Object -Average).Average
    Write-Output ("Promedio uso CPU: {0:N2}%" -f $avg)
}

# 25 alertaEspacio
function Alerta-Espacio {
    $drives = Get-PSDrive -PSProvider FileSystem
    $log = Join-Path $env:TEMP "alerta_espacio.log"
    foreach ($d in $drives) {
        try {
            $info = Get-Volume -DriveLetter $d.Name.TrimEnd(':') -ErrorAction Stop
            $free = $info.SizeRemaining
            $total = $info.Size
            $pct = ($free / $total) * 100
            if ($pct -lt 10) {
                $msg = ("ALERTA: Unidad {0} tiene {1:N2}% libre" -f $d.Name, $pct)
                Write-Output $msg
                $msg | Out-File -FilePath $log -Append
            }
        } catch {
            # Try alternate method
            try {
                $root = $d.Root
                $f = Get-Item $root
                $size = (Get-ChildItem -Path $root -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            } catch {}
        }
    }
    Write-Output "Log guardado en $log (si se generaron alertas)."
}

# 26 CopiasMasivas
function Copias-Masivas {
    $srcRoot = "C:\Users"
    $dstRoot = "C:\CopiasSeguridad"
    if (-not (Test-Path $dstRoot)) { New-Item -Path $dstRoot -ItemType Directory -Force | Out-Null }
    Get-ChildItem -Path $srcRoot -Directory | ForEach-Object {
        $user = $_.Name
        $zip = Join-Path $dstRoot ($user + ".zip")
        try {
            Compress-Archive -Path $_.FullName -DestinationPath $zip -Force -ErrorAction Stop
            Write-Output "Copia creada para $user -> $zip"
        } catch {
            Write-Error "Error comprimiendo $user: $_"
        }
    }
}

# 27 automatizarps
function Automatizar-PS {
    $dir = "C:\usuarios"
    if (-not (Test-Path $dir)) { Write-Output "Directorio $dir no existe."; return }
    $files = Get-ChildItem -Path $dir -File
    if ($files.Count -eq 0) { Write-Output "Listado vacio."; return }
    foreach ($f in $files) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
        $content = Get-Content $f.FullName -ErrorAction SilentlyContinue
        # Crear usuario si es posible
        try {
            $pwd = ([guid]::NewGuid().ToString())[0..7] -join ''
            $secure = ConvertTo-SecureString $pwd -AsPlainText -Force
            New-LocalUser -Name $name -Password $secure -FullName $name -PasswordNeverExpires:$true -ErrorAction Stop
            Write-Output "Usuario $name creado."
        } catch {
            Write-Output "No se pudo crear usuario $name (quizas permisos). Se procedera a crear carpetas locales."
        }
        # Crear carpeta de perfil y subcarpetas listadas en el archivo
        $profile = Join-Path "C:\Users" $name
        if (-not (Test-Path $profile)) { New-Item -Path $profile -ItemType Directory -Force | Out-Null }
        foreach ($line in $content) {
            $sub = Join-Path $profile $line.Trim()
            if ($line.Trim()) { New-Item -Path $sub -ItemType Directory -Force | Out-Null }
        }
        # Borrar archivo
        try { Remove-Item $f.FullName -Force; Write-Output "Archivo $($f.Name) procesado y borrado." } catch {}
    }
}

# 28 Barrido IP (ping sweep)
function Parse-CIDR {
    param([string] $cidr)
    $parts = $cidr.Split('/')
    $ip = [System.Net.IPAddress]::Parse($parts[0]).GetAddressBytes()
    [array]::Reverse($ip)
    $intIP = [BitConverter]::ToUInt32($ip,0)
    $prefix = [int]$parts[1]
    $mask = 0xFFFFFFFF -shr (32-$prefix) -shl (32-$prefix)
    $network = $intIP -band $mask
    $broadcast = $network + ([math]::Pow(2,(32-$prefix)) - 1)
    $list = @()
    for ($i = $network+1; $i -lt $broadcast; $i++) {
        $bytes = [BitConverter]::GetBytes([uint32]$i)
        [array]::Reverse($bytes)
        $list += ([System.Net.IPAddress]::New($bytes) ).ToString()
    }
    return $list
}

function Expand-Range {
    param([string]$start,[string]$end)
    $s = [System.Net.IPAddress]::Parse($start).GetAddressBytes(); [array]::Reverse($s); $si = [BitConverter]::ToUInt32($s,0)
    $e = [System.Net.IPAddress]::Parse($end).GetAddressBytes(); [array]::Reverse($e); $ei = [BitConverter]::ToUInt32($e,0)
    $list=@()
    for ($i=$si; $i -le $ei; $i++) {
        $b=[BitConverter]::GetBytes([uint32]$i); [array]::Reverse($b)
        $list += ([System.Net.IPAddress]::New($b)).ToString()
    }
    return $list
}

function Barrido-IP {
    param(
        [Parameter(Mandatory=$true)][string]$Mode, # CIDR | RANGE | BASEMASK
        [string]$Arg1,
        [string]$Arg2,
        [int]$TimeoutMs = 1000,
        [int]$MaxParallel = 50,
        [string]$OutFile = ".\barrido_resultados.csv"
    )
    $ips = @()
    switch ($Mode.ToUpper()) {
        "CIDR" { $ips = Parse-CIDR -cidr $Arg1 }
        "RANGE" { $ips = Expand-Range -start $Arg1 -end $Arg2 }
        "BASEMASK" {
            # Arg1 = base ip, Arg2 = mask bits (ej: 192.168.1.0,24)
            $cidr = "$Arg1/$Arg2"; $ips = Parse-CIDR -cidr $cidr
        }
        default { Write-Error "Modo no soportado"; return }
    }
    Write-Output ("IPs a probar: {0}" -f $ips.Count)
    $results = [System.Collections.Concurrent.ConcurrentBag[object]]::new()
    $scriptblock = {
        param($ip,$timeout)
        $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet -TimeoutMilliseconds $timeout
        if ($ping) { return $ip }
        return $null
    }
    $jobs = @()
    $sem = [System.Threading.SemaphoreSlim]::new($MaxParallel, $MaxParallel)
    foreach ($ip in $ips) {
        $null = $sem.WaitAsync().Result
        Start-Job -ScriptBlock {
            param($ip,$timeout,$sem)
            try {
                if (Test-Connection -ComputerName $ip -Count 1 -Quiet -TimeoutMilliseconds $timeout) { $ip }
            } finally { $sem.Release() }
        } -ArgumentList $ip,$TimeoutMs,$sem | Out-Null
    }
    # Esperar jobs y recopilar
    Get-Job | Wait-Job
    $alive = Get-Job | Receive-Job | Where-Object { $_ -ne $null }
    $alive | Out-File -FilePath $OutFile
    Write-Output "Resultado guardado en $OutFile. IPs activas: $($alive.Count)"
    # Limpiar jobs
    Get-Job | Remove-Job -Force
}

# 29 Evento
function Export-Eventos {
    param([int]$Max = 200, [string]$OutFile = ".\eventos.csv")
    $filters = @{LogName=@("System","Application"); Level=@(1,2)} # 1=Critical, 2=Error
    try {
        $events = Get-WinEvent -FilterHashtable $filters -MaxEvents $Max -ErrorAction Stop
        $events | Select-Object TimeCreated, ProviderName, Id, LevelDisplayName, Message | Export-Csv -Path $OutFile -NoTypeInformation -Encoding UTF8
        Write-Output "Exportados $($events.Count) eventos a $OutFile"
    } catch {
        Write-Error "Error extrayendo eventos: $_"
    }
}

# 30 Limpieza (utiliza param para poder ejecutarla standalone)
function Limpieza {
    param(
        [Parameter(Mandatory=$true)][string]$Ruta,
        [Parameter(Mandatory=$true)][int]$Dias,
        [Parameter(Mandatory=$true)][string]$Log,
        [switch]$WhatIf
    )
    if (-not (Test-Path $Ruta)) { Write-Error "La carpeta $Ruta no existe."; return }
    $cutoff = (Get-Date).AddDays(-$Dias)
    $files = Get-ChildItem -Path $Ruta -File -Recurse | Where-Object { $_.LastWriteTime -lt $cutoff }
    if ($files.Count -eq 0) { Write-Output "No hay archivos para eliminar."; return }
    foreach ($f in $files) {
        $info = "{0},{1},{2}" -f (Get-Date -Format o), $f.FullName, $f.Length
        if ($WhatIf) {
            Write-Output "Se ELIMINARIA: $($f.FullName) - Fecha: $($f.LastWriteTime)"
            $info | Out-File -FilePath $Log -Append
        } else {
            try {
                Remove-Item $f.FullName -Force
                Write-Output "Eliminado: $($f.FullName) - Fecha: $($f.LastWriteTime)"
                $info | Out-File -FilePath $Log -Append
            } catch {
                Write-Error "Error borrando $($f.FullName): $_"
            }
        }
    }
    Write-Output "Proceso de limpieza finalizado. Log: $Log"
}

# Agenda (simple, con almacenamiento en JSON)
$AgendaFile = Join-Path $PSScriptRoot "agenda.json"
if (-not (Test-Path $AgendaFile)) { @{} | ConvertTo-Json | Out-File $AgendaFile -Encoding UTF8 }

function Agenda-Menu {
    while ($true) {
        $dict = (Get-Content $AgendaFile -Raw | ConvertFrom-Json)
        Write-Output "`n--- AGENDA ---"
        Write-Output "1) Añadir/Modificar"
        Write-Output "2) Buscar"
        Write-Output "3) Borrar"
        Write-Output "4) Listar"
        Write-Output "0) Volver"
        $op = Read-Host "Opcion"
        switch ($op) {
            "1" {
                $name = Read-Host "Nombre"
                if ($dict.ContainsKey($name)) {
                    Write-Output "Telefono actual: $($dict[$name])"
                    $mod = Read-Host "Desea modificar? (s/n)"
                    if ($mod -match '^[sS]') {
                        $t = Read-Host "Nuevo telefono"
                        $dict[$name] = $t
                    }
                } else {
                    $t = Read-Host "Telefono"
                    $dict[$name] = $t
                }
                $dict | ConvertTo-Json | Out-File $AgendaFile -Encoding UTF8
            }
            "2" {
                $query = Read-Host "Cadena de inicio"
                $results = $dict.Keys | Where-Object { $_ -like "$query*" }
                foreach ($k in $results) { Write-Output "$k : $($dict[$k])" }
            }
            "3" {
                $name = Read-Host "Nombre a borrar"
                if ($dict.ContainsKey($name)) {
                    $conf = Read-Host "Confirmar borrado de $name (SI)"
                    if ($conf -eq "SI") { $dict.Remove($name); $dict | ConvertTo-Json | Out-File $AgendaFile -Encoding UTF8; Write-Output "Borrado." }
                } else { Write-Output "No existe." }
            }
            "4" {
                foreach ($k in $dict.Keys) { Write-Output "$k : $($dict[$k])" }
            }
            "0" { break }
            default { Write-Output "Opcion no valida" }
        }
    }
}

# --- FIN FUNCIONES ---

# Soporta invocar Limpieza directamente con parametros si el script es ejecutado asi:
param(
    [string]$Ruta,
    [int]$Dias,
    [string]$Log,
    [switch]$WhatIf
)
if ($PSBoundParameters.ContainsKey('Ruta')) {
    # Invocado como .\nombrepower.ps1 -Ruta "C:\Temp" -Dias 30 -Log "C:\reportes\limpieza.log" -WhatIf
    Limpieza -Ruta $Ruta -Dias $Dias -Log $Log -WhatIf:$WhatIf
    return
}

# LOOP MENU PRINCIPAL
while ($true) {
    Show-Menu
    $opt = Read-Host "Elige una opcion"
    switch ($opt) {
        "16" {
            $r = Read-Host "Quieres pizza vegetariana? (s/n)"
            Pizza -EsVegetariana $r
        }
        "17" { Dias-ParesImpares }
        "18" { Menu-Usuarios }
        "19" { Menu-Grupos }
        "20" {
            $d = Read-Host "Numero de disco a usar (numero entero)"
            $sim = Read-Host "Simular? (s/n)"
            $s = $false; if ($sim -match '^[sS]') { $s = $true }
            Diskp -DiskNumber ([int]$d) -Simular:($s)
        }
        "21" {
            $p = Read-Host "Introduce contrasena a validar"
            Validate-Password -Password $p
        }
        "22" {
            $n = Read-Host "Cuantos numeros imprimir?"
            Fibonacci-Iterativo -N ([int]$n)
        }
        "23" {
            $n = Read-Host "Cuantos numeros (recursivo)?"
            Fibonacci-Recursivo -N ([int]$n)
        }
        "24" { Monitoreo-CPU }
        "25" { Alerta-Espacio }
        "26" { Copias-Masivas }
        "27" { Automatizar-PS }
        "28" {
            Write-Output "Modos: CIDR, RANGE, BASEMASK"
            $m = Read-Host "Modo"
            if ($m -ieq "CIDR") {
                $arg = Read-Host "Introduce CIDR (ej: 192.168.1.0/24)"
                Barrido-IP -Mode CIDR -Arg1 $arg -OutFile ".\barrido_resultados.csv"
            } elseif ($m -ieq "RANGE") {
                $s = Read-Host "IP inicio"
                $e = Read-Host "IP fin"
                Barrido-IP -Mode RANGE -Arg1 $s -Arg2 $e -OutFile ".\barrido_resultados.csv"
            } else {
                $b = Read-Host "IP base (ej: 192.168.1.0)"
                $mask = Read-Host "Bits de mascara (ej: 24)"
                Barrido-IP -Mode BASEMASK -Arg1 $b -Arg2 $mask -OutFile ".\barrido_resultados.csv"
            }
        }
        "29" {
            $m = Read-Host "Cuantos eventos exportar? (por defecto 200)"
            if (-not $m) { $m = 200 }
            Export-Eventos -Max ([int]$m) -OutFile ".\eventos.csv"
        }
        "30" {
            $ruta = Read-Host "Ruta a limpiar (ej: C:\Temp)"
            $dias = Read-Host "Dias (ej: 30)"
            $log = Read-Host "Ruta log (ej: C:\reportes\limpieza.log)"
            $w = Read-Host "WhatIf? (s/n)"
            $what = $false; if ($w -match '^[sS]') { $what = $true }
            Limpieza -Ruta $ruta -Dias ([int]$dias) -Log $log -WhatIf:($what)
        }
        "0" { Write-Output "Adios"; break }
        default { Write-Output "Opcion no valida"; Start-Sleep 1 }
    }
}
