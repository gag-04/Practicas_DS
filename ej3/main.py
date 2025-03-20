#from interfaz import *
from patronDiseño import *

WEB = "https://quotes.toscrape.com"

opcion=0
usos =  1

while opcion != 3:
    opcion = int(input("\n\n Introduce 1 para usar Selenium, 2 para usar BeautifulSoup y 3 para salir del programa: "))

    scraper =  0

    if opcion == 1: 
        scraper = Estrategia(SeleniumScraper())
        metodo = "Selenium"

        

    elif opcion == 2:
        scraper = Estrategia(BeautifulSoupScraper())
        metodo = "BeautifulSoup"

    elif opcion == 3:
        print ("El programa ha sido finalizado correctamente.")

    else: 
        print("El valor que has introducido no es válido, vuelve a intentarlo.")


    if scraper != 0:
        datos = scraper.scrapear(WEB)
        
        if datos:
            nombreArchivo = "citas_"+ str(usos)+ "_" + metodo + ".yaml"
            with open(nombreArchivo, "w", encoding="utf-8") as archivo:
                yaml.dump(datos, archivo, allow_unicode=True, default_flow_style=False, sort_keys=False)
        else:
            print("Datos guardados en 'citas.yaml'.")

    usos += 1
  








