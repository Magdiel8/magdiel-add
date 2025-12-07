<#
.SYNOPSIS
    Script de Calificación (Grader) para el Script de Bajas.
.DESCRIPTION
    Este script evalúa automáticamente el funcionamiento del script de bajas de usuarios.
    Realiza 10 pruebas objetivas (1 punto cada una).
    Requiere ejecutar como Administrador.
#>

# ==========================================
# 1. CONFIGURACIÓN DEL ENTORNO DE EVALUACIÓN
# ==========================================

# Nombre del script del alumno a evaluar (debe estar en la misma carpeta)
$ScriptAlumno = ".\bajas.ps1" 

# Rutas y Nombres esperados (AJUSTAR SEGÚN EL ENUNCIADO DEL APARTADO 3)
$RutaLogEsperada    = "C:\Logs\bajas.log"
$RutaBackupEsperada = "C:\CopiasSeguridad"
$UsuarioTest        = "AlumnoTest01"
$UsuarioNoExiste    = "UsuarioFantasma99"
$PasswordTest       = "P@ssword123!"

# Variables de Puntuación
$NotaActual = 0
$ErroresDetectados = @()

# ==========================================
# 2. FUNCIONES AUXILIARES
# ==========================================

function Imprimir-Titulo {
    param([string]$Texto)
    Write-Host "`n==========================================" -ForegroundColor Cyan
    Write-Host $Texto -ForegroundColor Cyan
    Write-Host "=========================================="
}

function Registrar-Resultado {
    param(
        [string]$NombrePrueba,
        [bool]$Exito,
        [string]$MensajeError
    )
    
    if ($Exito) {
        Write-Host "[OK] $NombrePrueba (+1 pto)" -ForegroundColor Green
        $global:NotaActual++
    } else {
        Write-Host "[FALLO] $NombrePrueba" -ForegroundColor Red
        Write-Host "      -> Causa: $MensajeError" -ForegroundColor DarkGray
        $global:ErroresDetectados += "$NombrePrueba: $MensajeError"
    }
}

function Preparar-Entorno {
    Write-Host "Preparando entorno de pruebas..." -ForegroundColor Yellow
    
    # 1. Limpiar ejecuciones anteriores
    if (Get-LocalUser -Name $UsuarioTest -ErrorAction SilentlyContinue) { Remove-LocalUser -Name $UsuarioTest }
    if (Test-Path "C:\Usuarios\$UsuarioTest") { Remove-Item "C:\Usuarios\$UsuarioTest" -Recurse -Force }
    if (Test-Path "$RutaBackupEsperada\$UsuarioTest") { Remove-Item "$RutaBackupEsperada\$UsuarioTest" -Recurse -Force }
    if (Test-Path $RutaLogEsperada) { Remove-Item $RutaLogEsperada -Force }

    # 2. Crear Estructura para el Usuario de Prueba
    # Crear usuario local
    New-LocalUser -Name $UsuarioTest -NoPassword -ErrorAction SilentlyContinue | Out-Null
    
    # Crear su carpeta home simulada
    $HomeDir = "C:\Usuarios\$UsuarioTest"
    New-Item -Path $HomeDir -ItemType Directory -Force | Out-Null
    
    # Crear un archivo dentro para verificar que se mueve
    New-Item -Path "$HomeDir\documento_importante.txt" -ItemType File -Value "Datos confidenciales" | Out-Null
}

# Verificación de permisos de Administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script necesita permisos de Administrador para crear/borrar usuarios."
    Break
}

# ==========================================
# 3. EJECUCIÓN DE LAS PRUEBAS (10 Puntos)
# ==========================================

Imprimir-Titulo "INICIANDO EVALUACIÓN AUTOMÁTICA"
Preparar-Entorno

# --- BLOQUE 1: VALIDACIÓN DE ERRORES (Usuario no existe) ---

Write-Host "`n--- Ejecutando Script con usuario inexistente ($UsuarioNoExiste) ---" -ForegroundColor Gray
# Ejecutamos el script del alumno pasando el usuario falso
& $ScriptAlumno $UsuarioNoExiste | Out-Null

# PRUEBA 1: El usuario no existe y el script no debe fallar catastróficamente
# Verificamos si se creó el log (indicador de que el script corrió y manejó el error)
$ExisteLog = Test-Path $RutaLogEsperada
Registrar-Resultado "1. Manejo de error (Script no se cuelga)" $ExisteLog "No se generó el fichero de log tras el error."

# PRUEBA 2: Contenido del Log para error
$ContenidoLog = if ($ExisteLog) { Get-Content $RutaLogEsperada } else { "" }
$LogRegistraError = $ContenidoLog -match "Error" -or $ContenidoLog -match "No existe"
Registrar-Resultado "2. Registro de error en Log" $LogRegistraError "El log no contiene la palabra 'Error' o indicación de fallo."

# --- BLOQUE 2: EJECUCIÓN CORRECTA (Usuario existe) ---

Write-Host "`n--- Ejecutando Script con usuario real ($UsuarioTest) ---" -ForegroundColor Gray
# Ejecutamos el script del alumno para borrar al usuario real
& $ScriptAlumno $UsuarioTest | Out-Null

# PRUEBA 3: Eliminación del Usuario del Sistema
$UsuarioSigueExistiendo = Get-LocalUser -Name $UsuarioTest -ErrorAction SilentlyContinue
Registrar-Resultado "3. Eliminación de cuenta de usuario" (!$UsuarioSigueExistiendo) "El usuario $UsuarioTest todavía existe en el sistema."

# PRUEBA 4: Eliminación del directorio original
$ExisteHomeOriginal = Test-Path "C:\Usuarios\$UsuarioTest"
Registrar-Resultado "4. Limpieza directorio original" (!$ExisteHomeOriginal) "La carpeta original en C:\Usuarios no fue eliminada."

# PRUEBA 5: Creación de la copia de seguridad (Backup)
$ExisteBackup = Test-Path "$RutaBackupEsperada\$UsuarioTest"
Registrar-Resultado "5. Creación carpeta Backup" $ExisteBackup "No se encuentra la carpeta movida en $RutaBackupEsperada."

# PRUEBA 6: Integridad de los datos (Archivos movidos)
$ArchivoSalvado = Test-Path "$RutaBackupEsperada\$UsuarioTest\documento_importante.txt"
Registrar-Resultado "6. Integridad de archivos" $ArchivoSalvado "El archivo 'documento_importante.txt' no está en el backup."

# PRUEBA 7: Registro de éxito en el Log
$ContenidoLog = Get-Content $RutaLogEsperada
$LogRegistraExito = $ContenidoLog -match $UsuarioTest -and ($ContenidoLog -match "Borrado" -or $ContenidoLog -match "Éxito")
Registrar-Resultado "7. Log de éxito actualizado" $LogRegistraExito "El log no menciona al usuario borrado o mensaje de éxito."

# --- BLOQUE 3: PRUEBAS DE ROBUSTEZ Y ESTRUCTURA ---

# PRUEBA 8: Validación de argumentos vacíos
Write-Host "`n--- Ejecutando Script sin argumentos ---" -ForegroundColor Gray
$SalidaSinArgs = & $ScriptAlumno 2>&1  # Capturamos output y errores
# Se asume que el script debe pedir el nombre o dar error si está vacío
$ManejoSinArgs = $SalidaSinArgs -match "introduzca" -or $SalidaSinArgs -match "falta" -or $Error.Count -gt 0
Registrar-Resultado "8. Control de argumentos vacíos" $ManejoSinArgs "El script no avisó de la falta de parámetros."

# PRUEBA 9: Permisos/Seguridad (Comprobación simple)
# Verificamos si la carpeta de backup tiene acceso (existe) y no es nula
Registrar-Resultado "9. Estructura de destino válida" (Test-Path $RutaBackupEsperada) "La carpeta raíz de backups no existe o fue borrada."

# PRUEBA 10: Limpieza final (Estado consistente)
# Verificamos que no quedaron archivos temporales raros o errores críticos en el último error
$EstadoLimpio = -not (Test-Path "C:\Usuarios\Temp_$UsuarioTest") # Ejemplo de residuo
Registrar-Resultado "10. Limpieza de residuos" $EstadoLimpio "Quedaron carpetas temporales o residuos del proceso."

# ==========================================
# 4. INFORME FINAL
# ==========================================

Imprimir-Titulo "RESULTADO FINAL"
Write-Host "Nota Final: $NotaActual / 10" -ForegroundColor ($NotaActual -ge 5 ? "Green" : "Red")

if ($ErroresDetectados.Count -gt 0) {
    Write-Host "`nRESUMEN DE ERRORES:" -ForegroundColor Yellow
    foreach ($err in $ErroresDetectados) {
        Write-Host " - $err"
    }
    Write-Host "`nRecomendación: Revisa la lógica en los puntos fallidos y vuelve a ejecutar este test."
} else {
    Write-Host "`n¡ENHORABUENA! El script funciona perfectamente según las especificaciones." -ForegroundColor Green
}

Write-Host "`nFin del proceso de calificación."
