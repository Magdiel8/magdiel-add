# ---------------------------
# MENU PRINCIPAL
function MostrarMenu {
    Clear-Host
    Write-Host "=== MENU PRINCIPAL ==="
    Write-Host "16) Pizza"
    Write-Host "17) Dias (pares/impares anio bisiesto)"
    Write-Host "18) Menu usuarios"
    Write-Host "19) Menu grupos"
    Write-Host "20) Diskp"
    Write-Host "21) Contrasena"
    Write-Host "22) Fibonacci (iterativo)"
    Write-Host "23) Fibonacci (recursivo)"
    Write-Host "24) Monitoreo CPU"
    Write-Host "25) Alerta espacio"
    Write-Host "26) Copias masivas"
    Write-Host "27) Automatizar ps"
    Write-Host "28) Barrido"
    Write-Host "29) Evento"
    Write-Host "30) Limpieza"
    Write-Host "A) Agenda"
    Write-Host "0) Salir"
}

# ---------------------------
# 16 - Pizza
function Pizza {
    Clear-Host
    Write-Host "Pizzeria Bella Napoli"
    $tipo = Read-Host "Quieres pizza vegetariana? (s/n)"
    $vegIngredientes = @("Pimiento","Tofu")
    $noVegIngredientes = @("Peperoni","Jamon","Salmon")

    if ($tipo -match '^[sS]') {
        Write-Host "Ingredientes disponibles (ademas de tomate y mozzarella):"
        for ($i=0; $i -lt $vegIngredientes.Count; $i++) { Write-Host "[$($i+1)] $($vegIngredientes[$i])" }
        $sel = Read-Host "Elige 1 ingrediente (numero)"
        if ($sel -ge 1 -and $sel -le $vegIngredientes.Count) { $ingrediente = $vegIngredientes[$sel-1] } else { $ingrediente = $vegIngredientes[0] }
        $tipoStr = "Vegetariana"
    } else {
        Write-Host "Ingredientes disponibles (ademas de tomate y mozzarella):"
        for ($i=0; $i -lt $noVegIngredientes.Count; $i++) { Write-Host "[$($i+1)] $($noVegIngredientes[$i])" }
        $sel = Read-Host "Elige 1 ingrediente (numero)"
        if ($sel -ge 1 -and $sel -le $noVegIngredientes.Count) { $ingrediente = $noVegIngredientes[$sel-1] } else { $ingrediente = $noVegIngredientes[0] }
        $tipoStr = "No vegetariana"
    }

    Write-Host ""
    Write-Host "Tu pizza: $tipoStr"
    Write-Host "Ingredientes: Tomate, Mozzarella, $ingrediente"
    Read-Host "Presiona Enter para continuar..."
}

# ---------------------------
# 17 - Dias
function dias {
    Clear-Host
    Write-Host "En un anio bisiesto hay 366 dias."
    Write-Host "Dias pares: 179"
    Write-Host "Dias impares: 187"
    Read-Host "Presiona Enter para continuar..."
}

# ---------------------------
# 18 - Menu usuarios (simulado)
function menu_usuarios {
    Clear-Host
    Write-Host "Menu usuarios - funcionalidad simulada para principiantes"
    Read-Host "Presiona Enter para continuar..."
}

# ---------------------------
# 19 - Menu grupos (simulado)
function menu_grupos {
    Clear-Host
    Write-Host "Menu grupos - funcionalidad simulada para principiantes"
    Read-Host "Presiona Enter para continuar..."
}

# ---------------------------
# 20 - Diskp (informativo)
function diskp {
    Clear-Host
    Write-Host "DISKP - Script simplificado, no hace cambios reales"
    $diskNumber = Read-Host "Introduce numero de disco (ej: 0)"
    Write-Host "Simulando limpieza y particiones en disco $diskNumber..."
    Read-Host "Presiona Enter para continuar..."
}

# ---------------------------
# 21 - Contrasena
function contrasena {
    Clear-Host
    $password = Read-Host "Introduce la contrasena"
    $errores = @()
    if ($password.Length -lt 8) { $errores += "Debe tener al menos 8 caracteres" }
    if ($password -notmatch '[a-z]') { $errores += "Debe contener al menos una letra minuscula" }
    if ($password -notmatch '[A-Z]') { $errores += "Debe contener al menos una letra mayuscula" }
    if ($password -notmatch '\d') { $errores += "Debe contener al menos un numero" }
    if ($password -notmatch '[^a-zA-Z0-9]') { $errores += "Debe contener al menos un caracter especial" }

    if ($errores.Count -eq 0) { Write-Host "La contrasena es valida" } else {
        Write-Host "La contrasena NO es valida:"
        foreach ($e in $errores) { Write-Host " - $e" }
    }
    Read-Host "Presiona Enter para continuar..."
}

# ---------------------------
# 22 - Fibonacci iterativo
function Fibonacci {
    Clear-Host
    $n = [int](Read-Host "Cuantos numeros de Fibonacci quieres imprimir?")
    $a=0; $b=1
    for ($i=1; $i -le $n; $i++) {
        Write-Host $a
        $temp=$a+$b
        $a=$b
        $b=$temp
    }
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 23 - Fibonacci recursivo
function FibonacciRecursivo {
    Clear-Host
    function fib($n) { if ($n -le 1) { return $n } else { return fib($n-1)+fib($n-2) } }
    $n=[int](Read-Host "Cuantos numeros de Fibonacci quieres imprimir?")
    for ($i=0; $i -lt $n; $i++) { Write-Host (fib $i) }
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 24 - Monitoreo CPU
function monitoreo {
    Clear-Host
    Write-Host "Monitoreo CPU sencillo (30 segundos, cada 5s)"
    $total=0
    for ($i=1; $i -le 6; $i++) {
        $uso=(Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        $uso=[math]::Round($uso,2)
        Write-Host "Medicion $i : $uso %"
        $total+=$uso
        Start-Sleep -Seconds 5
    }
    Write-Host "Promedio de CPU: " + [math]::Round($total/6,2) + "%"
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 25 - Alerta espacio (simplificado)
function alertaEspacio {
    Clear-Host
    $drives = Get-PSDrive -PSProvider FileSystem
    foreach ($d in $drives) {
        $info = Get-Item $d.Root
        Write-Host "$($d.Name) - Capacidad disponible: $($info.PSIsContainer)"
    }
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 26 - Copias masivas (simulado)
function copiasMasivas {
    Clear-Host
    Write-Host "Copias masivas simuladas"
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 27 - Automatizar ps (simulado)
function automatizarps {
    Clear-Host
    Write-Host "Automatizar ps simulada"
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 28 - Barrido IP (simulado)
function barrido {
    Clear-Host
    Write-Host "Barrido IP simulado"
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 29 - Evento (simulado)
function evento {
    Clear-Host
    Write-Host "Exportar eventos simulados"
    Read-Host "Presiona Enter..."
}

# ---------------------------
# 30 - Limpieza (simulado)
function limpieza {
    Clear-Host
    Write-Host "Limpieza de archivos simulada"
    Read-Host "Presiona Enter..."
}

# ---------------------------
# Agenda
$Agenda=@{}
function AgendaMenu {
    while ($true) {
        Clear-Host
        Write-Host "AGENDA"
        Write-Host "1) Añadir/Modificar"
        Write-Host "2) Buscar por prefijo"
        Write-Host "3) Borrar"
        Write-Host "4) Listar"
        Write-Host "0) Volver"
        $op = Read-Host "Elige opcion"
        switch ($op) {
            "1" {
                $name=Read-Host "Nombre"
                $tel=Read-Host "Telefono"
                $Agenda[$name]=$tel
                Write-Host "Guardado."
                Read-Host "Enter..."
            }
            "2" {
                $pref=Read-Host "Prefijo"
                foreach ($k in $Agenda.Keys) { if ($k.StartsWith($pref)) { Write-Host "$k : $($Agenda[$k])" } }
                Read-Host "Enter..."
            }
            "3" {
                $name=Read-Host "Nombre a borrar"
                $Agenda.Remove($name)
                Write-Host "Borrado."
                Read-Host "Enter..."
            }
            "4" {
                foreach ($k in $Agenda.Keys) { Write-Host "$k : $($Agenda[$k])" }
                Read-Host "Enter..."
            }
            "0" { break }
            Default { Write-Host "Opcion no valida" }
        }
    }
}

# ---------------------------
# Bucle principal
do {
    MostrarMenu
    $opcion = Read-Host "Elige una opcion (0-30, A)"
    switch ($opcion) {
        "16" { Pizza }
        "17" { dias }
        "18" { menu_usuarios }
        "19" { menu_grupos }
        "20" { diskp }
        "21" { contrasena }
        "22" { Fibonacci }
        "23" { FibonacciRecursivo }
        "24" { monitoreo }
        "25" { alertaEspacio }
        "26" { copiasMasivas }
        "27" { automatizarps }
        "28" { barrido }
        "29" { evento }
        "30" { limpieza }
        "A" { AgendaMenu }
        "a" { AgendaMenu }
        "0" { Write-Host "Saliendo..." }
        Default { Write-Host "Opcion no valida"; Start-Sleep 1 }
    }
} while ($opcion -ne "0")
