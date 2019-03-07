#!/usr/bin/env python3

# Included in Python Standard Library
import time
# Third party library: http://docs.python-requests.org
import requests

# To install the requests packge:
# https://packaging.python.org/tutorials/installing-packages/
#
# Basic Installation: Install package globally
# run:
#   pip install "requests" 
#
# - or -
#
# Advanced Installation: Python “Virtual Environments” allow Python packages
#   to be installed in an isolated location for a particular application,
#   rather than being installed globally
# run (from within your project directory):
#   python3 -m venv codejam_env
#   source codejam_env/bin/activate
#   pip install "requests"


TEAM_NAME = "NAME-OF-YOUR-TEAM"
PREVIOUS_TEAM_NAME = "NAME-OF-TEAM-PRECEDING-YOURS-IN-CHAIN"

DEFAULT_BASE_URL = "https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/"
DATA_EXTENSION = ".json"

TRIGGER_KEY = "status"
TRIGGER_VALUE = "on"

READY_MESSAGE = "!!!GO GO GO!!!"

REQUEST_DELAY_SECONDS = 5

#-------------------------------------------------------------------------------
# Unnecessary main function used for code organization, called at end of file
def main():
#-------------------------------------------------------------------------------

    while True:
        try:
            json_data = get_data()
            print(json_data)
            if TRIGGER_KEY in json_data and json_data[TRIGGER_KEY] == TRIGGER_VALUE:
                on_ready()
                break
        except TypeError:
            print("Error: No data recieved")
            break
        except ValueError:
            print("Error: Invalid JSON recieved")
            break
        except requests.exceptions.HTTPError:
            print("Error: Bad request")
            break
        time.sleep(REQUEST_DELAY_SECONDS)

    # May be used to upload data for the next team
    #put_data({"custom_trigger_key": "custom_trigger_value"})

#-------------------------------------------------------------------------------
# Used to retrieve json data from the previous team
def get_data():
#-------------------------------------------------------------------------------
    url = build_url_get()
    headers =  {"Content-Type": "application/json", "cache-control": "no-cache"}
    response = requests.get(url, headers=headers)
    #Causes an exception to be raised upon a bad request
    response.raise_for_status()
    return response.json()

#-------------------------------------------------------------------------------
# Used to upload json data for the next team
def put_data(data):
#-------------------------------------------------------------------------------
    url = build_url_put()
    headers =  {"Content-Type": "application/json", "cache-control": "no-cache"}
    response = requests.put(url, headers=headers, json=data)    
    #Causes an exception to be raised upon a bad request
    response.raise_for_status()
    print(response.json())

#-------------------------------------------------------------------------------
def build_url_get():
#-------------------------------------------------------------------------------
    return DEFAULT_BASE_URL + PREVIOUS_TEAM_NAME + DATA_EXTENSION

#-------------------------------------------------------------------------------
def build_url_put():
#-------------------------------------------------------------------------------
    return DEFAULT_BASE_URL + TEAM_NAME + DATA_EXTENSION

#-------------------------------------------------------------------------------
# Called after a ready response is recieved from the previous team
def on_ready():
#-------------------------------------------------------------------------------
    print(READY_MESSAGE)

#-------------------------------------------------------------------------------
main()
#-------------------------------------------------------------------------------
