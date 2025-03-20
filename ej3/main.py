from Contexto import *
from Scraper import *
from SeleniumScraper import *
from BeautifulSoupScraper import *
import os

WEB = "https://quotes.toscrape.com"

opcion=0
usos =  1
carpetaSelenium = "Resultados/Selenium"
carpetaBeautifulSoup = "Resultados/BeautifulSoup"

while opcion != 3:
    opcion = int(input("\n\n Introduce 1 para usar Selenium, 2 para usar BeautifulSoup y 3 para salir del programa: "))

    scraper =  0

    if opcion == 1: 
        scraper = Estrategia(SeleniumScraper())
        carpeta = carpetaSelenium

    elif opcion == 2:
        scraper = Estrategia(BeautifulSoupScraper())
        carpeta = carpetaBeautifulSoup

    elif opcion == 3:
        print ("El programa ha sido finalizado correctamente.")

    else: 
        print("El valor que has introducido no es válido, vuelve a intentarlo.")

    if scraper != 0:
        datos = scraper.scrapear(WEB)
        
        if datos:
            if not os.path.exists(carpeta):
                os.makedirs(carpeta)

            nombreArchivo = "citas_" + str(usos) + ".yaml"
            ruta = os.path.join(carpeta, nombreArchivo)

            with open(ruta , "w", encoding="utf-8") as archivo:
                yaml.dump(datos, archivo, allow_unicode=True, default_flow_style=False, sort_keys=False)
            print("Datos guardados en " + os.path.realpath(ruta) + ".")
        else:
            print("No hay datos o ha habido un error.")

    usos += 1
