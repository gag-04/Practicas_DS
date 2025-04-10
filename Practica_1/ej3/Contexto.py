from Scraper import *

class Estrategia:
    def __init__(self, estrategia: Scraper):
        self.estrategia = estrategia
    
    def scrapear(self, web):
        return self.estrategia.scrapear(web)
