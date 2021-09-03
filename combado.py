import re
import collections
import requests
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.keys import Keys
import time

driver = webdriver.Chrome(ChromeDriverManager().install())
driver.get('https://web.whatsapp.com/')
time.sleep(30)
contatos = ['BOT DEM2']

def buscar_contato(contato):
    campo_pesquisa = driver.find_element_by_xpath('//div[contains(@class,"copyable-text selectable-text")]')
    time.sleep(1)
    campo_pesquisa.click()
    campo_pesquisa.send_keys(contato)
    campo_pesquisa.send_keys(Keys.ENTER)
    time.sleep(1)

def enviar_mensagem(mensagem):
    campo_mensagem = driver.find_elements_by_xpath('//div[contains(@class,"copyable-text selectable-text")]')
    campo_mensagem[1].click()
    time.sleep(1)
    campo_mensagem[1].send_keys(mensagem)
    campo_mensagem[1].send_keys(Keys.ENTER)

players = {'nome': 0}
for x in range(0, 1):
    r = requests.get(f"https://d2.demolidores.com.br/?subtopic=highscores&list=experience&world=0&page={x}").text
    regex = r"<td><a href=\"\?subtopic=characters&name=.+\">(.+?)<\/a><\/small><\/td><td>(\d+?)<\/td><td>.+<\/td><\/tr><tr bgcolor=\".+\">"
    matches = re.finditer(regex, r)
    for matchNum, match in enumerate(matches, start=1):
        players[match.group(1)] = int(match.group(2))

while 1:
    r = requests.get("https://d2.demolidores.com.br/?subtopic=highscores").text
    regex = r"<td><a href=\"\?subtopic=characters&name=.+\">(.+?)<\/a><\/small><\/td><td>(\d+?)<\/td><td>.+<\/td><\/tr><tr bgcolor=\".+\">"
    matches = re.finditer(regex, r)
    for matchNum, match in enumerate(matches, start=1):
        lvl = players.get(match.group(1))
        if lvl:
            diferenca = int(match.group(2)) - lvl
            if diferenca >= 5:
                for contato in contatos:
                    buscar_contato(contato)
                    enviar_mensagem(f"Player [*{match.group(1)}*] upou [*{diferenca}*] leveis em 15 min, lvl atual [*{match.group(2)}*] lvl por hora: *{diferenca * 4}*")
                    print(f"Player [{match.group(1)}] upou [{diferenca}] leveis 15 min, lvl atual [{match.group(2)}] lvl por hora: {diferenca * 4}")
            players[match.group(1)] = int(match.group(2))
        else:
            players[match.group(1)] = int(match.group(2))
    for contato in contatos:
         buscar_contato(contato)
         enviar_mensagem("*Aguardando 15 minutos para proxima checagem...*")
    time.sleep(900)
    print('-' * 30)