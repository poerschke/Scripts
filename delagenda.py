from __future__ import print_function
import datetime
import os.path
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import sys



SCOPES = ['https://www.googleapis.com/auth/calendar']

creds = Credentials.from_service_account_file('/var/www/service_account.json', scopes=SCOPES)
service = build('calendar', 'v3', credentials=creds)

def loga(agenda_id):
	arquivo = open("/var/www/agendamentos.log", "a")
	arquivo.write(f"Deletaou agenda_id: {agenda_id}\n")
	arquivo.close()

loga(sys.argv[1])
res = service.events().delete(calendarId='fabigotsoares@gmail.com', eventId = sys.argv[1]).execute()
