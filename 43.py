def sumar(a, b):
    """Suma dos números."""
    return a + b

def restar(a, b):
    """Resta dos números."""
    return a - b

def multiplicar(a, b):
    """Multiplica dos números."""
    return a * b

def dividir(a, b):
    """Divide dos números. Controla la división por cero."""
    if b == 0:
        return "Error: No se puede dividir por cero."
    else:
        return a / b

def main():
    print("--- CALCULADORA BÁSICA ---")
    
    # 1. Solicitamos los dos números (usamos float para permitir decimales)
    try:
        num1 = float(input("Introduce el primer número: "))
        num2 = float(input("Introduce el segundo número: "))
    except ValueError:
        print("Error: Por favor, introduce solo números válidos.")
        return

    # 2. Mostramos el menú
    print("\n¿Qué operación deseas realizar?")
    print("1. Sumar")
    print("2. Restar")
    print("3. Multiplicar")
    print("4. Dividir")

    # 3. Solicitamos la opción
    opcion = input("\nElige una opción (1-4): ")

    # 4. Llamamos a la función correspondiente
    if opcion == '1':
        resultado = sumar(num1, num2)
        print(f"El resultado de la suma es: {resultado}")
    
    elif opcion == '2':
        resultado = restar(num1, num2)
        print(f"El resultado de la resta es: {resultado}")
    
    elif opcion == '3':
        resultado = multiplicar(num1, num2)
        print(f"El resultado de la multiplicación es: {resultado}")
    
    elif opcion == '4':
        resultado = dividir(num1, num2)
        print(f"El resultado de la división es: {resultado}")
    
    else:
        # Manejo de entrada inválida del menú
        print("Error: Opción no válida. Por favor elige un número del 1 al 4.")

# Punto de entrada del programa
if __name__ == "__main__":
    main()
