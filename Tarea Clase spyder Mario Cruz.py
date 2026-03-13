# -*- coding: utf-8 -*-
"""
Created on Wed Oct  8 00:51:58 2025

@author: EQUIPO
"""
#Crear clase donde se pueda observar el inventario de una tienda de abarrotes y sus ventas.
class Tienda:
    def __init__(self, nombre):
        self.nombre = nombre
        self.inventario = {}  

    def agregar_producto(self, producto, precio, cantidad):
        """Agrega un producto al inventario"""
        try:
            if precio <= 0 or cantidad <= 0:
                return "FALSE El precio y la cantidad deben ser mayores que cero."
            
            self.inventario[producto] = [precio, cantidad]
            return f"TRUE Producto '{producto}' agregado con precio ${precio} y cantidad {cantidad}."
        
        except TypeError:
            return "FALSE Error: asegúrate de ingresar valores numéricos válidos."

    def mostrar_inventario(self):
        """Muestra todos los productos disponibles"""
        if not self.inventario:
            return "El inventario está vacío."
        
        print(f"Inventario de {self.nombre}:")
        for producto, datos in self.inventario.items():
            precio, cantidad = datos
            print(f"- {producto}: ${precio} ({cantidad} disponibles)")
        return ""

    def vender(self, producto, cantidad):
        """Realiza una venta y actualiza el inventario"""
        try:
            if producto not in self.inventario:
                return f"El producto '{producto}' no está disponible."
            
            precio, stock = self.inventario[producto]
            
            if cantidad > stock:
                return f"FALSE No hay suficiente stock de '{producto}'. Solo quedan {stock} unidades."
            
            total = precio * cantidad
            self.inventario[producto][1] -= cantidad  
            
            return f"Venta realizada: {cantidad} x '{producto}' = ${total}"
        
        except Exception as e:
            return f"FALSE Error durante la venta: {e}"

    def calcular_total(self):
        """Calcula el valor total del inventario"""
        try:
            total = 0
            for producto, datos in self.inventario.items():
                precio, cantidad = datos
                total += precio * cantidad
            return f"Valor total del inventario: ${total}"
        except Exception as e:
            return f"Error al calcular el total: {e}"


tienda = Tienda("ABARROTES MARIFER")

print(tienda.agregar_producto("Pan Bimbo mantecadas", 18, 47)) #agrega el producto con un precio de 18 y hay 47 stock
print(tienda.agregar_producto("Leche Lala", 21, 71)) #agrega el producto con un precio de 21 y hay 71 stock
print(tienda.agregar_producto("Pepsi 3lt", 40, 30)) #agrega el producto con precio de 8 y hay 30 stock
print(tienda.agregar_producto("Huevo Bachoco carton 18 piezas", -12, 10))  # Error lógico ,ya que, el precio esta en negativo
print(tienda.agregar_producto("Queso Oaxaca la Villita", "veinte", 5))  # Error de tipo porque el precio no esta con numeros


tienda.mostrar_inventario()

print(tienda.vender("Pan Bimbo mantecadas", 5)) #venta de 5 unidades
print(tienda.vender("Pepsi 3lt", 40))  # Sin suficiente stock
print(tienda.vender("Jumex mango 500ml", 2))       # Producto inexistente

print(tienda.calcular_total())