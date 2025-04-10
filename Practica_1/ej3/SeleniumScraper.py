from selenium import webdriver
from selenium.webdriver.common.by import By
from Scraper import *

class SeleniumScraper(Scraper):

    def scrapear(self,web):
        pausa = 2
        browser = webdriver.Firefox()
        browser.get(web)
        numCita = 1
        datos = []


        for paginasScrapeadas in range(0,self.paginasAScrapear):

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

            if paginasScrapeadas < self.paginasAScrapear-1:
                try:
                    boton = browser.find_element(By.XPATH, "/html/body/div/div[2]/div[1]/nav/ul/li[@class='next']/a")
                    boton.click() 
                except Exception as e:
                    print("No se encontró el botón o hubo un error:", e)

        
        browser.quit()

        return datos
