from abc import ABC, abstractmethod
from selenium import webdriver
#from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup
import requests
import yaml

<<<<<<< HEAD

filtroCita = "quote"
filtroTextoCita = "text"
filtroAutor = "author"
filtroEtiqueta = "tag"

=======
paginasAScrapear = 5
>>>>>>> parent of f0289f6 (Creadas variables para los filtros)


class Scraper(ABC):
    paginasAScrapear = 5
    @abstractmethod
    def scrapear(self,web):
        raise NotImplementedError("Es interfaz abstracta")


class SeleniumScraper(Scraper):

    def scrapear(self,web):
        pausa = 2
        #options = Options()
        #options.headless= True
        browser = webdriver.Firefox()#options=options)
        browser.get(web)
        numCita = 1
        datos = []


        for paginasScrapeadas in range(0,paginasAScrapear):

            browser.implicitly_wait(pausa)

            contenedores = browser.find_elements(By.CLASS_NAME, "quote")
            
            for contenedor in contenedores:
                cita = contenedor.find_element(By.CLASS_NAME, "text")
                autor = contenedor.find_element(By.CLASS_NAME, "author")
                etiquetas = contenedor.find_elements(By.CLASS_NAME, "tag")

                tags = [etiqueta.text.strip() for etiqueta in etiquetas]  

                datos.append({
                    "ID": numCita,
                    "Cita": cita.text,
                    "Autor": autor.text,
                    "Etiquetas": tags
                })


                numCita += 1

            if paginasScrapeadas < paginasAScrapear-1:
                try:
                    boton = browser.find_element(By.XPATH, "/html/body/div/div[2]/div[1]/nav/ul/li[@class='next']/a")
                    boton.click() 
                except Exception as e:
                    print("No se encontró el botón o hubo un error:", e)

        
        browser.quit()

        return datos



class BeautifulSoupScraper(Scraper):
    def scrapear(self, web):
        numCita = 1
        datos = []
        

        for paginasAScrapear in range(1,6):
            url = web + "/page/" + str(paginasAScrapear)
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


class Estrategia:
    def __init__(self, estrategia: Scraper):
        self.estrategia = estrategia
    
    def scrapear(self, web):
        return self.estrategia.scrapear(web)


