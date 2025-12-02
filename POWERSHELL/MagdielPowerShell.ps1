function MostrarMenu {
    Write-Host "===== MENU PRINCIPAL ====="
    Write-Host "1. Pizza"
    Write-Host "2. Dias"
    Write-Host  "3. Opcion 3"
    write-Host "4. Opcion 4"
    Write-Host "5. Opcion 5"
    Write-Host "6. Contrasena"
    Write-Host "7. Fibonacci"
    Write-Host "8. Opcion 8"
    Write-Host "9. Monitoreo de CPU"
    Write-Host "10. Opcion 10"
    Write-Host "11. Opcion 11"
    Write-Host "12. Opcion 12"
    Write-Host "..."
    Write-Host "30. Opcion 30"
    Write-Host "0. Salir"
}
# Ejercicio 16 - Pizza
function Pizza {
    Write-Host "Quieres una pizza vegetariana? (s/n)"
    $tipo = Read-Host
    if ($tipo -eq "s") {
        Write-Host "Ingredientes vegetarianos disponibles:"
        Write-Host "1. Pimiento"
        Write-Host "2. Tofu"
        $ing = Read-Host "Elige un ingrediente (1-2)"
        switch ($ing) {
            "1" { $ingrediente = "Pimiento" }
            "2" { $ingrediente = "Tofu" }
            Default { Write-Host "Opcion no valida. Se selecciona Pimiento."; $ingrediente = "Pimiento" }
        }
        $esVegetariana = $true
    } else {
        Write-Host "Ingredientes no vegetarianos disponibles:"
        Write-Host "1. Peperoni"
        Write-Host "2. Jamon"
        Write-Host "3. Salmon"
        $ing = Read-Host "Elige un ingrediente (1-3)"
        switch ($ing) {
            "1" { $ingrediente = "Peperoni" }
            "2" { $ingrediente = "Jamon" }
            "3" { $ingrediente = "Salmon" }
            Default { Write-Host "Opcion no valida. Se selecciona Peperoni."; $ingrediente = "Peperoni" }
        }
        $esVegetariana = $false
    }
    $tipoPizza = if ($esVegetariana) { "vegetariana" } else { "no vegetariana" }
    Write-Host "Tu pizza es $tipoPizza y lleva: mozzarella, tomate y $ingrediente."
    read-host "Presiona Enter para continuar..."
}
# Ejercicio 17 -Dias
function dias {
    $diasPar = 0
    $diasImpar = 0
    for($i = 1; $i -le 366; $i++){
        if($i % 2 -eq 0){
            $diasPar++
        } else {
            $diasImpar++
        }
    }
    write-host "Dias pares: $diasPar y dias impares: $diasImpar"
    read-host "Presiona Enter para continuar..."
}
# Ejerccio 21
function contrasena {
    $contra = Read-Host "Introduce una contrasena"
    $errores =@()
    if ($contra.Length -lt 8) {
        $errores += "La Contrasena debe tener al menos 8 caracteres."
    }
    if ($contra -notmatch '[A-Z]') {
        $errores += "La Contrasena debe contener al menos una letra mayúscula."
    }
    if ($contra -notmatch '[a-z]') {
        $errores += "La Contrasena debe contener al menos una letra minúscula."
    }
    if ($contra -notmatch '\d') {
        $errores += "La Contrasena debe contener al menos un número."
    }
    if ($contra -notmatch '[!@#$%^&*(),.?":{}|<>]') {
        $errores += "La contrasena debe contener al menos un carácter especial."
    }
    if ($errores.Count -eq 0) {
        Write-Host "Contrasena valida."
    } else {
        Write-Host "Contrasena inválida por las siguientes razones:"
        $errores | ForEach-Object { Write-Host "- $_" }
    }
read-host "Presiona Enter para continuar..."
}
#ejercico 22 no completado
function fibonacci{
    $n = read-host"pon un numero mayor que 0"
    if ($n -le 0) {
        write-host "El numero debe ser mayor que 0"
        return
    }
    $p = 0
    $b = 1
    for ($i = 1; $i -le $n; $i++) {
        write-host $p
        $s = $p + $b
        $p = $b
        $b = $s
    }
    write-host ""
    read-host "Presiona Enter para continuar..."
}
# Ejercicicio 22 

function monitoreo {
# Tiempo total en segundos
$duracion = 30
# Intervalo de medición en segundos
$intervalo = 5
# Lista para guardar las mediciones
$mediciones = @()

Write-Host " Iniciando monitoreo de CPU por $duracion segundos (medición cada $intervalo segundos)...`n"

# Bucle para tomar mediciones
for ($i = 1; $i -le ($duracion / $intervalo); $i++) {
    # Obtener uso de CPU actual
    $usoCPU = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $usoCPU = [math]::Round($usoCPU, 2)

    Write-Host "Medición $i : $usoCPU %"
    $mediciones += $usoCPU

    Start-Sleep -Seconds $intervalo
}

# Calcular promedio
$promedio = ($mediciones | Measure-Object -Average).Average
$promedio = [math]::Round($promedio, 2)

Write-Host "`n Promedio de uso de CPU: $promedio %"

Read-Host "Presiona Enter para continuar..."
}




# mostrar el menu
do {
    MostrarMenu
    $opcion = Read-Host "Elige una opcion (0-30)"
    switch ($opcion) {
        "1" {
            Pizza
        }
        "2" {
            dias
        }
        "6" {
            contrasena 
        }
        "7" {
            fibonacci
        }
        "9" {
            monitoreo
        }
        "0" {
            Write-Host "Saliendo del programa..."
        }
        Default {
            Write-Host "Opcion no valida. Intenta de nuevo."
        }
    }
} while ($opcion -ne "0")