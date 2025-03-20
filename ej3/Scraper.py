from abc import ABC, abstractmethod


import yaml


class Scraper(ABC):
    paginasAScrapear = 5
    @abstractmethod
    def scrapear(self,web):
        raise NotImplementedError("Es interfaz abstracta")



