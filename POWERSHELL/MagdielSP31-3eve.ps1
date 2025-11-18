
# Esto hace que el menú sirva para cualquier ordenador
$logsDisponibles = Get-EventLog -List

do {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "         SELECTOR DE REGISTROS DE EVENTOS"
    Write-Host "=================================================="
    
    # Generamos el menú dinámicamente recorriendo la lista de logs
    # $i es el contador para poner los números (1, 2, 3...)
    for ($i = 0; $i -lt $logsDisponibles.Count; $i++) {
        # Mostramos: Numero. NombreDelLog (Ej: 1. Application)
        Write-Host "$($i + 1). $($logsDisponibles[$i].Log)"
    }
    
    Write-Host "0. Salir"
    Write-Host "=================================================="

    $opcion = Read-Host "Seleccione el número del registro a visualizar"

    # Si la opción es 0, salimos del bucle
    if ($opcion -eq "0") {
        Write-Host "Saliendo del script..."
        break
    }

    # Validación: Comprobamos si lo escrito es un número válido
    if ($opcion -match "^\d+$" -and $opcion -gt 0 -and $opcion -le $logsDisponibles.Count) {
        
        # Convertimos la opción a índice del array (restando 1 porque los arrays empiezan en 0)
        $indice = [int]$opcion - 1
        $logSeleccionado = $logsDisponibles[$indice]
        
        Write-Host "`n--- Mostrando los últimos 12 eventos de: $($logSeleccionado.Log) ---"
        
        try {
            # Obtenemos los 12 últimos eventos del log seleccionado
            Get-EventLog -LogName $logSeleccionado.Log -Newest 12 -ErrorAction Stop | 
            Format-Table TimeGenerated, EntryType, Message -AutoSize
        }
        catch {
            Write-Host "`nERROR: No se pudo leer el registro '$($logSeleccionado.Log)'." -ForegroundColor Red
            Write-Host "Posibles causas: El log está vacío o necesitas permisos de Administrador."
        }

        Write-Host "`n---------------------------------------------------"
        Read-Host "Presiona ENTER para volver al menú"
    }
    else {
        Write-Host "Opción no válida. Por favor, introduce un número del menú."
        Start-Sleep -Seconds 2
    }


} until ($opcion -eq "0")
