import requests
import re
from win32com.client import Dispatch
import html
from io import StringIO
from html.parser import HTMLParser
import json


class MLStripper(HTMLParser):
    def __init__(self):
        super().__init__()
        self.reset()
        self.strict = False
        self.convert_charrefs= True
        self.text = StringIO()
    def handle_data(self, d):
        self.text.write(d)
    def get_data(self):
        return self.text.getvalue()

def strip_tags(html):
    s = MLStripper()
    s.feed(html)
    return s.get_data()

speak = Dispatch("SAPI.SpVoice")

pagina = requests.get("https://olhardigital.com.br/").text



regex = r"<a class=\"read\-more\" href=\"(.+?)\">Leia mais<\/a>"
noticias = re.finditer(regex, pagina)

for num, noticia in enumerate(noticias, start=1):
    materia = requests.get(noticia.group(1)).text
    regex2 = r"<link rel=\"alternate\" type=\"application\/json\" href=\"(.+?)\">"
    link = re.findall(regex2, materia, re.DOTALL)[0]
    print(link)
    js = json.loads(html.unescape(requests.get(link).text))
    titulo = js["title"]["rendered"]
    texto = js["content"]["rendered"]
    texto= re.sub(r'<ul>.+?<\/ul>',' ',texto)
    texto = re.sub(r'<strong>.+?<\/strong>',' ',texto)
    texto = strip_tags(html.unescape(texto))
    print(titulo)
    speak.Speak(titulo)
    """
    print(texto)
    speak.Speak(texto)
    """
