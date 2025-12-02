

param(
    [Parameter(Mandatory=$true)]
    [string]$FechaInicio,

    [Parameter(Mandatory=$true)]
    [string]$FechaFin
)

# Forzamos a PowerShell a usar día/mes/año
$formato = "d/M/yyyy" 
$cultura = [System.Globalization.CultureInfo]::InvariantCulture

try {
    # Convertimos el texto a fecha usando la regla estricta
    $Inicio = [DateTime]::ParseExact($FechaInicio, $formato, $cultura)
    $Fin    = [DateTime]::ParseExact($FechaFin, $formato, $cultura)
    
    # Ajustamos la fecha fin para incluir todo ese día
    $Fin = $Fin.AddDays(1).AddTicks(-1)
}
catch {
    Write-Error "Error: La fecha debe ser DÍA/MES/AÑO (Ej: 20/11/2025)."
    exit
}

Write-Host "Buscando eventos desde $Inicio hasta $Fin ..."
Write-Host "-----------------------------------------------------"

# Buscamos los eventos ID 4624 (Logon)
try {
    $eventos = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        ID        = 4624
        StartTime = $Inicio
        EndTime   = $Fin
    } -ErrorAction Stop
}
catch {
    Write-Host "No se encontraron eventos o faltan permisos de Administrador."
    exit
}

$resultados = foreach ($evento in $eventos) {
    $usuario = $evento.Properties[5].Value

    # Filtramos SYSTEM y cuentas de máquina
    if ($usuario -ne "SYSTEM" -and $usuario -ne "NT AUTHORITY\SYSTEM" -and $usuario -notlike "*$") {
        [PSCustomObject]@{
            Dia     = $evento.TimeCreated.ToString("dd/MM/yyyy")
            Hora    = $evento.TimeCreated.ToString("HH:mm:ss")
            Usuario = $usuario
        }
    }
}

if ($resultados) {
    $resultados | Format-Table -AutoSize
    Write-Host "Total registros encontrados: $($resultados.Count)"
} else {
    Write-Host "No hay registros en ese rango (excluyendo SYSTEM)."
}
