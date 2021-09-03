from __future__ import print_function
import datetime
import os.path
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import sys


SCOPES = ['https://www.googleapis.com/auth/calendar']

event_id = sys.argv[1]
dia = sys.argv[2]
inicio = sys.argv[3]
fim = sys.argv[4]

creds = Credentials.from_service_account_file('/var/www/service_account.json', scopes=SCOPES)
service = build('calendar', 'v3', credentials=creds)

def loga(agenda_id, i_o, f_o, i_n, f_n):
	arquivo = open("/var/www/agendamentos.log", "a")
	arquivo.write(f"Agenda_id: {agenda_id} de: {i_o} ate: {f_o} para de: {i_n} ate: {f_n}\n")
	arquivo.close()

event = service.events().get(calendarId='fabigotsoares@gmail.com', eventId = event_id).execute()

loga(event_id, event['start']['dateTime'], event['end']['dateTime'], dia+'T'+inicio + '-03:00', dia+'T'+fim +'-03:00')

event['start']['dateTime'] = dia+'T'+inicio + '-03:00'
event['end']['dateTime'] = dia+'T'+fim +'-03:00'

updated_event = service.events().update(calendarId='fabigotsoares@gmail.com', eventId=event['id'], body=event).execute()