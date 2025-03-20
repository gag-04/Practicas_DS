from Scraper import *
from bs4 import BeautifulSoup
import requests


class BeautifulSoupScraper(Scraper):
    def scrapear(self, web):
        numCita = 1
        datos = []
        

        for paginasRestantes in range(1,self.paginasAScrapear+1):
            url = web + "/page/" + str(paginasRestantes)
            respuesta = requests.get(url)
                
            if respuesta.status_code == 200:
                sopa = BeautifulSoup(respuesta.text, "html.parser")

                contenedores = sopa.find_all(class_="quote")

                for contenedor in contenedores:
                    cita = contenedor.find(class_="text")
                    autor = contenedor.find(class_="author")
                    etiquetas = contenedor.find_all(class_ ="tag")

                    tags = [etiqueta.text.strip() for etiqueta in etiquetas]

                    datos.append({
                        "ID": numCita,
                        "Cita": cita.text,
                        "Autor": autor.text,
                        "Etiquetas": tags
                    })
                    numCita+=1


        return datos