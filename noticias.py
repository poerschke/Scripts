import requests
import re
from win32com.client import Dispatch
import html
import json


speak = Dispatch("SAPI.SpVoice")

pagina = requests.get("https://olhardigital.com.br/").text

regex = r"<a href=\"(.+?)\" class=\"artifact blk-item i-cover\" data-img=\".+\" data-id=\"\d+\" data-tipo=\"1\" data-hubkey=\".+\" data-pos=\"\d+\" title=\"(.+?)\">"
noticias = re.finditer(regex, pagina)

for num, noticia in enumerate(noticias, start=1):
	
	print(f"#{num} Título: {noticia.group(2)}")
	speak.Speak(noticia.group(2))

	materia = requests.get(f"https:{noticia.group(1)}").text

	regex2 = r"<script type=\"application\/ld\+json\">(.+?)<\/script>"
	texto = json.loads(html.unescape(re.findall(regex2, materia, re.DOTALL)[0]))

	print(texto["articleBody"])
	speak.Speak(texto["articleBody"])