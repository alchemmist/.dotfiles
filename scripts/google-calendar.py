import datetime
import json 
import os.path
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# Если измените эти области видимости, удалите файл token.json
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
CLIENT_FILE = '/home/alchemmist/.secrets/client_secret_1062888509271-qjg5i29c20ullk3aj4crja613nutv7et.apps.googleusercontent.com.json'

def get_next_event():
    creds = None
    # Файл token.json хранит пользовательский токен и обновляет его автоматически.
    if os.path.exists("token.json"):
        creds = Credentials.from_authorized_user_file("token.json", SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                CLIENT_FILE, SCOPES)
            creds = flow.run_local_server(port=0)
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    service = build('calendar', 'v3', credentials=creds)

    now = (datetime.datetime.now() - datetime.timedelta(hours=2)).isoformat() + 'Z'
    events_result = service.events().list(calendarId='primary', timeMin=now,
                                          maxResults=10, singleEvents=True,
                                          orderBy='startTime').execute()
    events = events_result.get('items', [])

    if not events:
        print("No events")
        exit(0)

    main_event = events[0]
    start = main_event['start'].get('dateTime', main_event['start'].get('date'))
    main_event_time = datetime.datetime.fromisoformat(start).replace(tzinfo=None)
    time = main_event_time.strftime('%H:%M')
    date = main_event_time.strftime('%d.%m.%Y')

    time_until_main_event = main_event_time - datetime.datetime.now().replace(tzinfo=None)
    time_until_minutes = time_until_main_event.total_seconds() / 60
    main_event_class = "alert" if time_until_minutes < 30 else "normal"

    if (is_tomorrow := main_event_time.date() == (datetime.datetime.now() \
            + datetime.timedelta(days=1)).date()):
        date_text = main_event_time.strftime('%d.%m')
    else:
        date_text = ""


    output_text = f"{time} {main_event['summary']}" if not is_tomorrow else f"{date_text.replace("0", "")} в {time} {main_event['summary']}"
    truncated_text = output_text[:23] + ".."

    return json.dumps({
            "text": truncated_text,
            "tooltip": f"{time} {date}",
            "class": main_event_class
        }
    )


print(get_next_event())

