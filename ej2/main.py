from interfaz import *
from patronDiseño import *

WEB = "https://ejemplo.com"

opcion=0

while opcion != 3:
    opcion = int(input("\n\n Introduce 1 para usar Selenium, 2 para usar BeautifulSoup y 3 para salir del programa: "))

    if opcion == 1: 
        SeleniumScraper.scrapear(WEB)

    elif opcion == 2:
        BeautifulSoupScraper.scrapear(WEB)

    elif opcion == 3:
        print ("El programa ha sido finalizado correctamente.")

    else: 
        print("El valor que has introducido no es válido, vuelve a intentarlo.")



  








