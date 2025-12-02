
function Mostrar-Menu {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "          VISOR DE EVENTOS (Con fechas)"
    Write-Host "=================================================="
    Write-Host "1. Mostrar listado de los eventos del sistema"
    Write-Host "2. Mostrar errores del sistema (Último mes)"
    Write-Host "3. Mostrar Warning - Esta semana"
    Write-Host "Q. Salir"
    Write-Host "=================================================="
}

# Bucle 
do {
    Mostrar-Menu
    $opcion = Read-Host "Seleccione una opción"

    # Evalúa la opción ingresada
    switch ($opcion) {
        "1" {
            Write-Host "`n--- Listado de eventos del Sistema (Recientes) ---"
            
            # Obtiene los 20 últimos eventos 
            Get-EventLog -LogName System -Newest 20 | Format-Table TimeGenerated, EntryType, Source, Message -AutoSize
            
            Write-Host "`n---------------------------------------------------"
            Read-Host "Presiona ENTER para volver al menú" # Pausa la ejecución
        }
        "2" {
            Write-Host "`n--- Errores del Sistema (Último mes) ---"
            
            # Calcula la fecha actual menos 1 mes
            $fechaLimite = (Get-Date).AddMonths(-1)
            Write-Host "Buscando errores posteriores a: $fechaLimite"
            
            # Bloque Try/Catch para manejar si no se encuentran resultados
            try {
                # Filtra errores 
                $errores = Get-EventLog -LogName System -EntryType Error -After $fechaLimite -ErrorAction Stop
                # Selecciona los primeros 20 
                $errores | Select-Object -First 20 | Format-List TimeGenerated, Source, Message
            }
            catch {
                Write-Host "`nNo se encontraron errores en el último mes." # Mensaje si falla la búsqueda
            }
            
            Write-Host "`n---------------------------------------------------"
            Read-Host "Presiona ENTER para volver al menú" # Pausa la ejecución
        }
        "3" {
            Write-Host "`n--- Advertencias de Aplicaciones (Esta semana) ---"
            # Calcula la fecha 
            $fechaLimite = (Get-Date).AddDays(-7)
            Write-Host "Buscando warnings posteriores a: $fechaLimite"
            
            try {
                # Filtra warnings 
                $warnings = Get-EventLog -LogName Application -EntryType Warning -After $fechaLimite -ErrorAction Stop
                # Muestra los primeros 20 en formato lista
                $warnings | Select-Object -First 20 | Format-List TimeGenerated, Source, Message
            }
            catch {
                Write-Host "`nNo se encontraron advertencias en la última semana."
            }
            
            Write-Host "`n---------------------------------------------------"
            Read-Host "Presiona ENTER para volver al menú"
        }
        "Q" { 
            Write-Host "Saliendo..." 
        }
        "q" { 
            $opcion = "Q"
            Write-Host "Saliendo..." 
        }
        default { 
            Write-Host "Opción no válida." 
            Start-Sleep -Seconds 1 # Pequeña espera 
        }
    }
} until ($opcion -eq "Q") 