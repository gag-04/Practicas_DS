from abc import ABC, abstractmethod


class Scrap(ABC):
    @abstractmethod
    def scrapear(self,web):
        raise NotImplementedError("Es interfaz abstracta")

class SeleniumScraper(Scrap):
    def scrapear(self,web):
        print(" En Selenium: " + web)

class BeautifulSoupScraper(Scrap):
    def scrapear(self, web):
        print(" En Beautiful Soup: " + web)






class Estrategia:
    def __init__(self, estrategia: Scrap):
        self.estrategia = estrategia
    
    def scrapear(self, web):
        self.estrategia.scrapear(web)


