#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Python version 2.7.12
# Call Workfusion API using Requests library.
# Persistent session is created with parameters:
# Cookie: JSESSIONID
# Header: X-CSRF-TOKEN

# Usage: python2 ./workfusion_api.py <user_id> <user_firstname> <user_lastname>
# Update login_user, login_pass, and uuid variables at the bottom of the script.
# Script will attempt two API calls after authentication: Service Info and Start Task File


import sys
import json
import requests
from base64 import b64encode
from HTMLParser import HTMLParser


# Global Definitions
HOSTNAME = "host.domain.com"
BASE_URL = "https://" + HOSTNAME + "/workfusion/api/"
LOGIN_URL = "https://" + HOSTNAME + "/workfusion/dologin"


class MyHTMLParser(HTMLParser):

    def handle_starttag(self, tag, attrs):
        meta = dict()
        if tag == 'meta' and attrs[0][1] == '_csrf':
            for attr in attrs:
                meta[str(attr[0])] = str(attr[1])
            # print meta['name']
            # print meta['content']
            self.csrf = meta['content']
        if tag == 'meta' and attrs[0][1] == '_csrf_header':
            for attr in attrs:
                meta[str(attr[0])] = str(attr[1])
            # print meta['name']
            # print meta['content']
            self.csrf_token_name = meta['content']
        return


class TaskStart():

    def set_workforceUuid(self, uuid):
        self.workforceUuid = uuid
    
    def set_campaignUuid(self, uuid):
        self.campaignUuid = uuid

    def set_mainData(self, mainData):
        self.mainData = mainData


def gen_user_data(user_id, user_first, user_last):
    csv_data = "user_id,user_fname,user_lname\n{0},{1},{2}".format(user_id, user_first, user_last)
    csv_data = b64encode(csv_data)
    return csv_data


def gen_session_params(session, response):
    html = response.text
    parser = MyHTMLParser()
    parser.feed(html)

    jsession_id = session.cookies['JSESSIONID']
    csrf = parser.csrf
    csrf_token_name = parser.csrf_token_name
    return jsession_id, csrf_token_name, csrf


def login(session, login_url, login_user, login_pass):
    data = { 'j_username': login_user, 'j_password': login_pass }
    req = session.post(url=login_url, data=data)
    return req


def service_info(session, base_url):
    url = base_url + "/v2/workfusion/service/info"
    req = session.get(url)
    return req


def start_task(session, base_url, headers, uuid):
    url = base_url + "/v2/workfusion/task/" + uuid + "/start"
    req = session.post(url, headers=headers)
    return req


def start_task_file(session, base_url, headers, uuid, csv_data):
    url = base_url + "/v2/workfusion/task/file"
    taskstart = TaskStart()
    taskstart.set_campaignUuid(uuid)
    taskstart.set_mainData(csv_data)
    json_data = json.dumps(taskstart.__dict__)
    req = session.post(url, data=json_data, headers=headers)
    return req

def main():
    ## Create session and send login request
    session = requests.Session()
    response = login(session, LOGIN_URL, login_user, login_pass)

    ## Get JSESSIONID and CSRF Token
    jsession_id, csrf_token_name, csrf = gen_session_params(session, response)
    print "Session Info:"
    print "JSESSIONID: ", jsession_id
    print csrf_token_name, ":", csrf
    print "-----------------------------------"

    ## Generate Headers
    headers = {"Content-Type": "application/json",
                csrf_token_name: csrf }

    ## API calls
    si = service_info(session, BASE_URL)
    print "API Call: Service Info"
    print si.text.encode('utf-8')
    print si
    print "-----------------------------------"

    # st = start_task(session, BASE_URL, headers, uuid)
    # print "API Call: Start Task"
    # print st.text.encode('utf-8')
    # print st
    # print "-----------------------------------"

    # Set user info
    csv_data = gen_user_data(user_id, user_first, user_last)

    # Start Task with UUID and csv file
    stf = start_task_file(session, BASE_URL, headers, uuid, csv_data)
    print stf.text.encode('utf-8')
    print stf
    print "-----------------------------------"


if __name__ == '__main__':
    ## API Login Info
    login_user = '<username>'
    login_pass = '<password>'

    ## Business Process UUID
    uuid = "6c8cded3-a737-4563-a370-c0420efd0341"

    ## Set User Info from script arguments
    args = sys.argv
    user_id = args[1]
    user_first = args[2]
    user_last = args[3]

    main()
