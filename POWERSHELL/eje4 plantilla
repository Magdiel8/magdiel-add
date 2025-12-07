# =============================================================================
# NOMBRE DEL SCRIPT: nombre04.ps1
# DESCRIPCIÓN: Script de calificación para 'magdielAdrian03.ps1'
# REQUISITOS: Ejecutar como Administrador.
# =============================================================================

# --- 0. COMPROBACIÓN DE PRIVILEGIOS ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script necesita permisos de Administrador para crear y borrar usuarios de prueba."
    Write-Warning "Por favor, ejecuta PowerShell como Administrador."
    Break
}

Clear-Host
Write-Host "=========================================================="
Write-Host "   CALIFICANDO SCRIPT: magdielAdrian03.ps1                "
Write-Host "=========================================================="

# --- CONFIGURACIÓN ESPECÍFICA ---
# Nombre del script del alumno que vamos a evaluar
$scriptAlumno    = ".\magdielAdrian03.ps1"

# Nombre del fichero que se generará para la prueba (según tu petición)
$ficheroBajasTest= ".\bajas.txt" 

$rutaProyecto    = ".\proyecto"
$rutaLogs        = ".\Logs"
$nota            = 0
$errores         = @()
$totalPruebas    = 10

# Usuarios que usaremos para la simulación
$usrTest1 = "TestUser01" # Usuario válido
$usrTest2 = "TestFake99" # Usuario inventado para forzar error

# --- 1. PREPARACIÓN DEL ENTORNO (SETUP) ---
Write-Host "`n[1/3] PREPARANDO ENTORNO DE PRUEBAS..."

# 1.1 Limpieza de ejecuciones anteriores
try {
    Write-Host " -> Limpiando entorno previo..."
    Remove-LocalUser -Name $usrTest1 -ErrorAction SilentlyContinue
    if (Test-Path "C:\Users\$usrTest1") { Remove-Item "C:\Users\$usrTest1" -Recurse -Force -ErrorAction SilentlyContinue }
    if (Test-Path $rutaProyecto) { Remove-Item $rutaProyecto -Recurse -Force -ErrorAction SilentlyContinue }
    if (Test-Path $rutaLogs) { Remove-Item $rutaLogs -Recurse -Force -ErrorAction SilentlyContinue }
    if (Test-Path $ficheroBajasTest) { Remove-Item $ficheroBajasTest -Force }
} catch {
    Write-Host "Aviso: Limpieza inicial con advertencias (no crítico)."
}

# 1.2 Crear Usuario de Prueba Real
try {
    Write-Host " -> Creando usuario de prueba: $usrTest1"
    $pass = ConvertTo-SecureString "Pass1234." -AsPlainText -Force
    New-LocalUser -Name $usrTest1 -Password $pass -Description "Usuario Test Calificacion" | Out-Null
    
    # Crear carpetas y datos dummy
    $homeDir = "C:\Users\$usrTest1"
    $workDir = "$homeDir\trabajo"
    New-Item -Path $workDir -ItemType Directory -Force | Out-Null
    
    Set-Content -Path "$workDir\doc1.txt" -Value "Datos confidenciales 1"
    Set-Content -Path "$workDir\foto.jpg" -Value "Imagen binaria simulada"
    Set-Content -Path "$workDir\nota.log" -Value "Log interno"
    
    Write-Host " -> Datos generados en $workDir"
} catch {
    Write-Error "FALLO CRÍTICO: No se pudo crear el usuario. Verifica permisos de Admin."
    Break
}

# 1.3 Generar fichero bajas.txt con los casos de prueba
# (1 usuario real, 1 usuario falso)
$contenido = @"
Juan:Perez:Gomez:$usrTest1
Usuario:Falso:Inexistente:$usrTest2
"@
Set-Content -Path $ficheroBajasTest -Value $contenido
Write-Host " -> Fichero de entrada '$ficheroBajasTest' generado correctamente."

# --- 2. EJECUCIÓN DEL SCRIPT DEL ALUMNO ---
Write-Host "`n[2/3] EJECUTANDO SCRIPT DEL ALUMNO..."

if (-not (Test-Path $scriptAlumno)) {
    Write-Error "ERROR: No se encuentra el archivo '$scriptAlumno' en esta carpeta."
    Break
}

# Ejecución llamando al script del alumno y pasándole el fichero bajas.txt
$output = & $scriptAlumno $ficheroBajasTest 2>&1

Write-Host " -> Script ejecutado. Iniciando validación..."

# --- 3. VALIDACIÓN Y CALIFICACIÓN ---
Write-Host "`n[3/3] AUDITORÍA Y PUNTUACIÓN"
Write-Host "----------------------------------------------------------"

# PRUEBA 1: Usuario eliminado
$test1 = Get-LocalUser -Name $usrTest1 -ErrorAction SilentlyContinue
if (-not $test1) {
    Write-Host "[OK] (+1) Usuario $usrTest1 eliminado del sistema."
    $nota++
} else {
    Write-Host "[FAIL] (0) El usuario $usrTest1 sigue existiendo."
    $errores += "Fallo al eliminar usuario local."
}

# PRUEBA 2: Carpeta Home eliminada
if (-not (Test-Path "C:\Users\$usrTest1")) {
    Write-Host "[OK] (+1) Carpeta personal original eliminada."
    $nota++
} else {
    Write-Host "[FAIL] (0) La carpeta C:\Users\$usrTest1 aún existe."
    $errores += "No se borró el directorio personal."
}

# PRUEBA 3: Carpeta Backup creada
$backupDir = "$rutaProyecto\$usrTest1"
if (Test-Path $backupDir) {
    Write-Host "[OK] (+1) Carpeta de backup creada en $backupDir."
    $nota++
} else {
    Write-Host "[FAIL] (0) No existe carpeta backup en $rutaProyecto."
    $errores += "No se creó carpeta destino."
}

# PRUEBA 4: Ficheros movidos
$filesCount = (Get-ChildItem $backupDir -File -ErrorAction SilentlyContinue).Count
if ($filesCount -eq 3) {
    Write-Host "[OK] (+1) Se movieron 3 archivos correctamente."
    $nota++
} else {
    Write-Host "[FAIL] (0) Esperados 3 archivos, encontrados: $filesCount."
    $errores += "Fallo en movimiento de archivos."
}

# PRUEBA 5: Log Bajas existe
$logBajas = "$rutaLogs\bajas.log"
if (Test-Path $logBajas) {
    Write-Host "[OK] (+1) Fichero bajas.log creado."
    $nota++
} else {
    Write-Host "[FAIL] (0) No se encontró bajas.log."
    $errores += "Falta log de bajas."
}

# PRUEBA 6: Contenido Log Bajas
$contentLog = Get-Content $logBajas -ErrorAction SilentlyContinue
if ($contentLog -match $usrTest1) {
    Write-Host "[OK] (+1) Log bajas registra al usuario correcto."
    $nota++
} else {
    Write-Host "[FAIL] (0) Log bajas vacío o incorrecto."
    $errores += "Contenido de log de bajas erróneo."
}

# PRUEBA 7: Log Errores existe
$logError = "$rutaLogs\bajaserror.log"
if (Test-Path $logError) {
    Write-Host "[OK] (+1) Fichero bajaserror.log creado."
    $nota++
} else {
    Write-Host "[FAIL] (0) No se encontró bajaserror.log."
    $errores += "Falta log de errores."
}

# PRUEBA 8: Contenido Log Errores
$contentError = Get-Content $logError -ErrorAction SilentlyContinue
if ($contentError -match $usrTest2) {
    Write-Host "[OK] (+1) Log errores registra al usuario inexistente."
    $nota++
} else {
    Write-Host "[FAIL] (0) Log errores no menciona al usuario $usrTest2."
    $errores += "Contenido de log de errores erróneo."
}

# PRUEBA 9: Control sin argumentos
Write-Host " -> Test argumento vacío..."
$outputSinArgs = & $scriptAlumno 2>&1
if ($outputSinArgs -match "Error" -or $outputSinArgs -match "Uso") {
    Write-Host "[OK] (+1) Control de argumentos correcto."
    $nota++
} else {
    Write-Host "[FAIL] (0) El script no validó la falta de argumentos."
    $errores += "Falta validación de argumentos."
}

# PRUEBA 10: Control fichero inexistente
Write-Host " -> Test fichero inexistente..."
$outputNoFile = & $scriptAlumno "archivo_fantasma.txt" 2>&1
if ($outputNoFile -match "no existe") {
    Write-Host "[OK] (+1) Control de fichero inexistente correcto."
    $nota++
} else {
    Write-Host "[FAIL] (0) El script no validó fichero inexistente."
    $errores += "Falta validación de existencia del fichero."
}

# --- 4. RESULTADO FINAL ---
Write-Host "=========================================================="
Write-Host "                   NOTA FINAL: $nota / 10                 "
Write-Host "=========================================================="

if ($errores.Count -gt 0) {
    Write-Host "`nERRORES DETECTADOS:"
    foreach ($err in $errores) {
        Write-Host " [X] $err"
    }
} else {
    Write-Host "`n¡SCRIPT PERFECTO!"
}
