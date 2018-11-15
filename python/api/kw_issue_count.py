#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Python version 2.7.14

# Generate Klocwork issue count by project and build number. Sorted by date into CSV per project.
# Update user under Global Definitions (line 18), and put corresponding 'ltoken' file in the same directory as this script.
# Usage: python ./kw_issue_count.py -d <number of days>


from datetime import datetime, timedelta
import argparse
import urllib2
import urllib
import json
import os


# Global Definitions
port = 443
host = 'klocwork.domain.com'
url = 'https://%s:%d/review/api' % (host, port)
user = 'username'
token_file = './ltoken'
output_dest = 'output'


def parse_args():
    parser = argparse.ArgumentParser(description='Generates Klocwork report by project')
    parser.add_argument('-d', '--days', help='Specify which issues to pull')
    args = parser.parse_args()
    days = int(args.days)
    return days


def gen_dirs(path):
    if not os.path.exists(os.path.dirname(path)):
        try:
            os.makedirs(os.path.dirname(path))
        except OSError:
            raise


def get_token(token_file):
    with open(token_file, 'r') as file:
        for item in file:
            elem = item.strip().split(';')
    return elem[3]


def report(url, user, token, action, **kwargs):
    params = {'user': user, 'ltoken': token, 'action': action}
    if ('project' in kwargs):
        params['project'] = kwargs['project']
    if ('query' in kwargs):
        params['query'] = kwargs['query']
    if ('id' in kwargs):
        params['id'] = kwargs['id']

    data = urllib.urlencode(params)
    req = urllib2.Request(url, data)
    response = urllib2.urlopen(req)
    return response


def get_project(project_list, project):
    for record in project_list:
        data = json.loads(record)
        if str(data['name']) == project:
            return data


def get_issues_open(url, user, token, project_name, **kwargs):
    if ('build_num' in kwargs):
        build_num = kwargs['build_num']
        query_string = 'status:+Analyze,+Fix build:' + str(build_num)
    else:
        query_string = 'status:+Analyze,+Fix'
    issues = report(url, user, token, project=project_name,
                    action='search',
                    query=query_string)
    return issues


def get_builds(url, user, token, project_name):

    def from_json(json_object):
        return Build(json_object)

    data = []
    build_list = report(url, user, token, project=project_name,
                        action='builds')
    for record in build_list:
        data.append(json.loads(record, object_hook=from_json))
    return data


class Build(object):
    def __init__(self, attrs):
        self.id = attrs['id']
        self.name = attrs['name']
        self.date = datetime.fromtimestamp(int(attrs['date'])/1000, None)
        self.keepit = attrs['keepit']


def main():

    projects = [
    'project_1',
    'project_2',
    'project_3'
    ]

    days = parse_args()
    token = get_token(token_file)
    output_dest = 'output'
    output_path = os.path.join(os.path.join(output_dest, ''))
    gen_dirs(output_path)

    build_url_string_01 = "https://klocwork.domain.com/review/insight-review.html#issuelist_goto:project="
    build_url_string_02 = ",searchquery=build%253A'"
    build_url_string_03 = "'+status%253A%252BAnalyze%252C%252BFix,sortcolumn=id,sortdirection=ASC,view_id=1"

    for project in projects:
        project_list = report(url, user, token, action='projects')
        project_info = get_project(project_list, project)
        project_id = project_info['id']
        project_name = project_info.get('name', None)
        print 'Project Name: %s' % project_name
        filename = output_path + project + '.csv'
        builds = get_builds(url, user, token, project_name)
        builds.reverse()

        with open(filename, 'w') as file:
            file.write('Date,Issue Count,Build URL,\n')
            for build in builds:
                if build.date <= (datetime.today() - timedelta(days=days)):
                    continue
                issues = get_issues_open(url, user, token, project_name, build_num=build.id)
                issue_list = list(issues)
                build_count = len(issue_list)
                build_date = build.date

                build_num = 'build_' + str(build.id)
                build_url = '"' + build_url_string_01 + project_id + build_url_string_02 + build_num + build_url_string_03 + '"'

                file.write("{0},{1},{2},\n".format(build_date, build_count, build_url))
                print 'Build: {0} - Date: {1} - Total issues: {2}'.format(build_num, build_date, build_count)


main()
