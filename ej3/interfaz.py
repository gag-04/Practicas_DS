import _tkinter as tk
from tkinter import ttk
from patronDiseño import *


def mostrarPantalla(frame):
    # pack_forget() -> Método de la clase Frame para ocultar un widget que ha sido posicionado en la interfaz
    pantallaInicial.pack_forget()

    # pack() -> Método de la clase Frame que muestra un widget en la pantalla
    frame.pack(fill = 'both', expand = True) 



def cargarPantallaInicio(app):
    app.geometry("800x600")  # geometry() -> establecer tamaño de la ventana
    app.title("Ejercicio 3 - Práctica 1 - DS")

    mostrarPantalla(pantallaInicial)

    # Creación de botón
    # lambda permite que se ejecute la función solo cuando se haga click sobre el botón
    btnIniciar = tk.Button(
        pantallaInicial, 
        text = "Iniciar",
        width = 10,
        height = 3,
        relief = "groove", 
        borderwidth = 2,
        bg = "#CCFF99",
        font=("Arial", 16),
    )

    # Ubicación de botón en el centro de la pantalla
    btnIniciar.place(x=400, y=450, anchor="center")



app = tk.Tk()
opcion = tk.IntVar()





# Creación de los frames para cada opción y menú
pantallaInicial = tk.Frame(app, bg = "lightblue")   

cargarPantallaInicio(app)