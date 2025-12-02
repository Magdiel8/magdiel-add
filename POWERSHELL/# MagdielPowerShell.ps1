# MagdielPowerShell.ps1

function MostrarMenu {
    Write-Host "===== MENÚ PRINCIPAL ====="
    Write-Host "1. Pizza"
    Write-Host "2. Opción 2"
    Write-Host "3. Opción 3"
    Write-Host "..."
    Write-Host "30. Opción 30"
    Write-Host "0. Salir"
}
# Ejercicio 16 - Pizza
function Pizza {
    Write-Host "¿Quieres una pizza vegetariana? (s/n)"
    $tipo = Read-Host
    if ($tipo -eq "s") {
        Write-Host "Ingredientes vegetarianos disponibles:"
        Write-Host "1. Pimiento"
        Write-Host "2. Tofu"
        $ing = Read-Host "Elige un ingrediente (1-2)"
        switch ($ing) {
            "1" { $ingrediente = "Pimiento" }
            "2" { $ingrediente = "Tofu" }
            Default { Write-Host "Opción no válida. Se selecciona Pimiento."; $ingrediente = "Pimiento" }
        }
        $esVegetariana = $true
    } else {
        Write-Host "Ingredientes no vegetarianos disponibles:"
        Write-Host "1. Peperoni"
        Write-Host "2. Jamón"
        Write-Host "3. Salmón"
        $ing = Read-Host "Elige un ingrediente (1-3)"
        switch ($ing) {
            "1" { $ingrediente = "Peperoni" }
            "2" { $ingrediente = "Jamón" }
            "3" { $ingrediente = "Salmón" }
            Default { Write-Host "Opción no válida. Se selecciona Peperoni."; $ingrediente = "Peperoni" }
        }
        $esVegetariana = $false
    }
    $tipoPizza = if ($esVegetariana) { "vegetariana" } else { "no vegetariana" }
    Write-Host "Tu pizza es $tipoPizza y lleva: mozzarella, tomate y $ingrediente."
}

#mostrar menu
$opcion = ""
while ($opcion -ne "0" ) {
   
    $opcion = Read-Host "Elige una opción (0-30)"
    switch ($opcion) {
        "1" {
            $param1 = Read-Host "Introduce el parámetro para la opción 1"
            Opcion1 -param1 $param1
        }
        "2" {
            $param2 = Read-Host "Introduce el primer parámetro para la opción 2"
            $param3 = Read-Host "Introduce el segundo parámetro para la opción 2"
            Opcion2 -param2 $param2 -param3 $param3
        }
        # ... Añadir casos para las opciones 3 a 30
        "0" {
            Write-Host "Saliendo del programa..."
        }
        Default {
            Write-Host "Opción no válida. Intenta de nuevo."
        }
    }
} 