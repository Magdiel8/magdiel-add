# Esto es para que sirva en cualquier pc
$logsDisponibles = Get-EventLog -List

do {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "         SELECTOR DE REGISTROS DE EVENTOS"
    Write-Host "=================================================="
    
    #captamos las opciones disponibles
    for ($i = 0; $i -lt $logsDisponibles.Count; $i++) {
      
        Write-Host "$($i + 1). $($logsDisponibles[$i].Log)"
    }
    
    Write-Host "0. Salir"
    Write-Host "=================================================="

    $opcion = Read-Host "Seleccione el numero del registro a visualizar"

    # opcion para salir 
    if ($opcion -eq "0") {
        Write-Host "Saliendo del script..."
        break
    }

    # Validación:
    if ($opcion -match "^\d+$" -and $opcion -gt 0 -and $opcion -le $logsDisponibles.Count) {
        
        # Convertimos la opción a índice 
        $indice = [int]$opcion - 1
        $logSeleccionado = $logsDisponibles[$indice]
        
        Write-Host "`n--- Mostrando los ultimos 12 eventos de: $($logSeleccionado.Log) ---"
        
        try {
            # Obtenemos los 12 últimos 
            Get-EventLog -LogName $logSeleccionado.Log -Newest 12 -ErrorAction Stop | 
            Format-Table TimeGenerated, EntryType, Message -AutoSize
        }
        catch {
            Write-Host "`nERROR: No se pudo leer el registro '$($logSeleccionado.Log)'." 
            Write-Host "Posibles causas: El log esta vacio o necesitas permisos de Administrador."
        }

        Write-Host "`n---------------------------------------------------"
        Read-Host "Presiona ENTER para volver al menu"
    }
    else {
        Write-Host "Opción no valida. Por favor, introduce un numero del menu."
        Start-Sleep -Seconds 2
    }


} until ($opcion -eq "0")

