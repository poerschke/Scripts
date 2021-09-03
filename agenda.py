from __future__ import print_function
import datetime
import os.path
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import sys
import mysql.connector



SCOPES = ['https://www.googleapis.com/auth/calendar']

creds = Credentials.from_service_account_file('/var/www/service_account.json',scopes=SCOPES)
service = build('calendar', 'v3', credentials=creds)


def loga(nome, terapia, dia, inicio, fim, bid):
	arquivo = open("/var/www/agendamentos.log", "a")
	arquivo.write(f"Nome: {nome} Terapia: {terapia} Dia: {dia} Inicio: {inicio} Fim: {fim} Booking: {bid}\n")
	arquivo.close()


def cria_evento(nome, terapia, dia, inicio, fim, bid):
	loga(nome, terapia, dia, inicio, fim, bid)
	"""
	2021-04-14T19:00:00-03:00
	"""
	event = {
    	'summary': nome + ' : '+ terapia,
    	'location': 'Rua da República 567 Sala 208, Cidade Baixa - Porto Alegre - RS',
    	'description': terapia,
    	'start': {
    	    'dateTime': dia+'T'+inicio + '-03:00',
    	    'timeZone': 'America/Sao_Paulo'
    	},
    	'end': {
    	    'dateTime': dia+'T'+fim +'-03:00',
    	    'timeZone': 'America/Sao_Paulo'
    	},
    	'status': 'confirmed',
    	'visibility' : 'public',
    	'reminders': {
    	    'useDefault': False,
    	    'overrides': [
    	        {'method': 'email', 'minutes': 24 * 60},
    	        {'method': 'popup', 'minutes': 30},
    	    ],
    	},
	}
	event = service.events().insert(calendarId='fabigotsoares@gmail.com', body=event).execute()
	atualiza_agenda_site(bid, event['id'])
	
def atualiza_agenda_site(id, event_id):
	mydb = mysql.connector.connect(
	host="localhost",
	user="user",
	passwd="senha",
	database="bdados")

	cursor = mydb.cursor()
	sql = f"UPDATE bookings SET agenda_id = '{event_id}' WHERE id = {id}"
	cursor.execute(sql)
	mydb.commit()

if len(sys.argv) != 7 :
	print(f"Modo de uso: {sys.argv[0]} <nome paciente> <nome terapia> <dia> <inicio> <fim> <booking_id>")
	os._exit(1)

cria_evento(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])
