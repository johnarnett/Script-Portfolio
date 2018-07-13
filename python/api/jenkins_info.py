#!/usr/bin/env python
# -*- coding: utf-8

# Generate job / build information from Jenkins API


import os
import json
import codecs
import requests


# Global Definitions
user = 'john.arnett'
token = 'xxxxxxxxxx'
base_url = 'https://<jenkins_server>/job/'
params = {'pretty': 'true'}
project = 'Project_Name'
rootPath = os.getcwd() + '/output/'
fname = rootPath + 'summary.txt'


def getJobList(base_url, project):
    # returns array of jobs
    jobs = []
    url = base_url + project + '/api/json?tree=jobs[name]'
    response = requests.get(url, auth=(user, token), params=params)
    json_data = json.loads(response.text)
    for i in range(len(json_data['jobs'])):
        jobs.append(json_data['jobs'][i]['name'])
    return jobs


def getJobInfo(base_url, project, job):
    url = base_url + project + '/job/' + job + '/api/json'
    response = requests.get(url, auth=(user, token), params=params)
    json_data = json.loads(response.text)
    return json_data


def getFailedBuild(job_info):
    if job_info.get('lastFailedBuild', ''):
        return job_info.get('lastFailedBuild', '')


def getFailedBuildNum(failed_build):
    return failed_build['number']


def getCompletedBuild(job_info):
    if job_info.get('lastCompletedBuild', ''):
        return job_info.get('lastCompletedBuild', '')


def getCompletedBuildNum(completed_build):
    return completed_build['number']


def writeItem(file, itemTitle, item):
    if item:
        file.write("{0}:\t{1}\n".format(itemTitle, item))


def gen_dirs(fname):
    if not os.path.exists(os.path.dirname(fname)):
        try:
            os.makedirs(os.path.dirname(fname))
        except OSError:  # Guard against race condition
            raise


# MAIN
job_list = getJobList(base_url, project)
print job_list[1]

gen_dirs(fname)
with codecs.open(fname, 'w', "utf-8") as f:
    for job in job_list:
        job_info = getJobInfo(base_url, project, job)
        failed_build = getFailedBuild(job_info)
        failed_build_num = getFailedBuildNum(failed_build)
        completed_build = getCompletedBuild(job_info)
        completed_build_num = getCompletedBuildNum(completed_build)

        if completed_build_num < failed_build_num:
            continue
        else:

            print failed_build['url']
            failed_url = failed_build['url'] + '/api/json'
            response = requests.get(failed_url,
                                    auth=(user, token),
                                    params=params)

            json_data = json.loads(response.text)
            changeSet = json_data.get('changeSet', '')
            status = json_data.get('result', '')
            items = changeSet.get('items', {})
            writeItem(f, 'Job Name', job)
            writeItem(f, 'Job URL', failed_build['url'])
            writeItem(f, 'Job Status', status)
            for item in range(len(items)):
                writeItem(f, 'Name', items[item]['author']['fullName'])
                writeItem(f, 'Change Number', items[item]['changeNumber'])
                writeItem(f, 'Change Time', items[item]['changeTime'])
                writeItem(f, 'Commit ID', items[item]['commitId'])
                writeItem(f, 'Time Stamp', items[item]['timestamp'])
                writeItem(f, 'Commit msg', items[item]['msg'])

                f.write('Path:\n')
                for path in items[item]['affectedPaths']:
                    print path
                    f.write('\t{0}\n'.format(path))

                print items[item]['msg']
                print items[item]['changeNumber']
                print items[item]['changeTime']
                print items[item]['commitId']
                print items[item]['timestamp']

            f.write('\n\n')

#EOF
