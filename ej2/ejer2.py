import json
import requests 
from transformers import pipeline
from abc import ABC, abstractmethod

'''abrir archivo donde esta el token, se tiene que crear archivo llamado:token.json y meter el token de huggingface, llamado:HUGGINGFACE_API_KEY'''
with open("token.json", "r") as file:
    config = json.load(file)

API_KEY = config["HUGGINGFACE_API_KEY"]    
HEADERS = {"Authorization": f"Bearer  {API_KEY}", "Content-Type": "entrada/json"}

class LLM(ABC):
    """Clase base abstracta para los modelos de lenguaje, es una interfaz"""
    @abstractmethod
    def generate_summary(self, texto, input_lang, output_lang, model_llm):
        pass

class BasicLLM(LLM):
    """Clase que genera un resumen utilizando la API de Hugging Face."""
    def __init__(self, api_key):
        self.api_key = api_key

    def generate_summary(self, texto, input_lang, output_lang, model_llm):
        """Genera un resumen del texto utilizando el modelo especificado."""
        url = f"https://api-inference.huggingface.co/models/{model_llm}"
        payload = json.dumps({"inputs": texto})
        
        try:
            response = requests.post(url, headers=HEADERS, data=payload, timeout=60)
            response.raise_for_status()  # Lanza un error si la respuesta es 4xx o 5xx
            result = response.json()
            

            return result[0].get('summary_text', "Error: No se pudo generar el resumen.")
        except requests.exceptions.RequestException as e:
            return f"Error en la API: {e}"

class LLMDecorator(LLM):
    """Clase decoradora base."""
    def __init__(self, wrapped:LLM):
        self.wrapped = wrapped

    def generate_summary(self, texto, input_lang, output_lang, model_llm):
        return self.wrapped.generate_summary(texto, input_lang, output_lang, model_llm)

class TranslationDecorator(LLMDecorator):
    """Decora el LLM base para traducir el resumen generado."""
    def __init__(self, wrapped, translation_model):
        super().__init__(wrapped)
        self.translation_model = translation_model
        

    def translate(self, texto):
        """Traduce el texto utilizando la API de Hugging Face."""
        url = f"https://api-inference.huggingface.co/models/{self.translation_model}"
        payload = json.dumps({"inputs": texto})

        try:
            response = requests.post(url, headers=HEADERS, data=payload, timeout=60)
            response.raise_for_status()
            result = response.json()
            

            return result[0].get('translation_text', "Error en la traducción.")
        except requests.exceptions.RequestException as e:
            return f"Error en la API de traducción: {e}"

    def generate_summary(self, texto, input_lang, output_lang, model_llm):
        resumen = self.wrapped.generate_summary(texto, input_lang, output_lang, model_llm)
        return self.translate(resumen)

class ExpansionDecorator(LLMDecorator):
    """Decora el LLM base para expandir el resumen generado."""
    def __init__(self, wrapped, expansion_model):
        super().__init__(wrapped)
        self.expansion_model = expansion_model
        

    def expand(self, texto):
        """Expande el resumen utilizando la API de Hugging Face."""
        url = f"https://api-inference.huggingface.co/models/{self.expansion_model}"
        payload = json.dumps({"inputs": texto})

        try:
            response = requests.post(url, headers=HEADERS, data=payload, timeout=60)
            response.raise_for_status()
            result = response.json()
            

            return result[0].get('generated_text', "Error en la expansión.")
        except requests.exceptions.RequestException as e:
            return f"Error en la API de expansión: {e}"

    def generate_summary(self, texto, input_lang, output_lang, model_llm):
        resumen = self.wrapped.generate_summary(texto, input_lang, output_lang, model_llm)
        return self.expand(resumen)

# --- Código cliente ---
def main():
    print("Iniciando la función main...")
    try:
        # Cargar configuración desde JSON
        with open("entrada.json", "r") as file:
            config = json.load(file)
        print("Archivo JSON cargado correctamente.")

        

        texto = config["texto"]
        input_lang = config["input_lang"]
        output_lang = config["output_lang"]
        model_llm = config["model_llm"]
        model_translation = config["model_translation"]
        model_expansion = config["model_expansion"]
        
        print("Texto a procesar:", texto)

        # Instanciar el LLM base
        llm = BasicLLM(API_KEY)

        # Generar resumen básico
        resumen_basico = llm.generate_summary(texto, input_lang, output_lang, model_llm)
        print("\nResumen básico:")
        print(resumen_basico)

        # Aplicar decorador de traducción
        llm_traducido = TranslationDecorator(llm, model_translation)
        resumen_traducido = llm_traducido.generate_summary(texto, input_lang, output_lang, model_llm)
        print("\nResumen traducido:")
        print(resumen_traducido)

        # Aplicar decorador de expansión
        llm_expandido = ExpansionDecorator(llm, model_expansion)
        resumen_expandido = llm_expandido.generate_summary(texto, input_lang, output_lang, model_llm)
        print("\nResumen expandido:")
        print(resumen_expandido)

         # Aplicar ambos decoradores (primero traducir y luego expandir)
        llm_completo = ExpansionDecorator(llm_traducido, model_expansion)
        resumen_completo = llm_completo.generate_summary(texto, input_lang, output_lang, model_llm)
        print("\nResumen traducido y expandido:")
        print(resumen_completo)
       
    except FileNotFoundError:
        print("Error: No se encontró el archivo 'entrada.json'.")
    except json.JSONDecodeError:
        print(" Error: Formato JSON inválido.")

if __name__ == "__main__":
    main()
