#!/usr/bin/env python
# -*- coding: utf-8

# Python version: 2.7.14
# Author: John Arnett
# Date: 2/12/2018

# Generate issues by project from Klocwork code analysis. Outputs to CSV

# Usage:
# python main.py -p <PROJECT NAME> -i <{reconciled, open}>

# Example syntax:
# python main.py -p <project_name> -b
# python main.py -p <project_name> -c
# python main.py -p <project_name> -i open
# python main.py -p <project_name> -i reconciled


import os
import time
import json
import urllib
import urllib2
import argparse


def parse_args():
    parser = argparse.ArgumentParser(description='Generates Klocwork report by project')
    group = parser.add_mutually_exclusive_group()
    parser.add_argument('-p', '--project', required=True, help='Specify a project NAME (not ID)')
    group.add_argument('-b', '--build', action='store_true', help='Set this flag to view builds')
    group.add_argument('-c', '--checkers', action='store_true', help='Set this flag to view checkers')
    group.add_argument('-i', '--issue', choices=['open','reconciled'], help='Specify which issues to pull')

    args = parser.parse_args()
    project = args.project
    issue_search = args.issue
    show_builds = args.build
    show_checkers = args.checkers
    return project, issue_search, show_builds, show_checkers


def gen_dirs(path):
    print 'Path: %s' % path
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


def avg_response(response_times):
    sum = 0
    for i in range(len(response_times)):
        sum += response_times[i]
    average = round(sum / len(response_times), 2)
    return average


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


def get_issues_open(url, user, token, project_name):
    issues = report(url, user, token, project=project_name,
                    action='search',
                    query='status:Analyze,Fix')
    return issues


def get_issues_reconciled(url, user, token, project_name):
    issues = report(url, user, token, project=project_name,
                    action='search',
                    query='status:Defer,Ignore,Not a Problem')
    return issues


def get_issue_details(url, user, token, project_name, issue_id):
    details = report(url, user, token, project=project_name,
                     action='issue_details', id=issue_id)
    return details


def get_builds(url, user, token, project_name):

    def from_json(json_object):
        return Build(json_object)

    data = []
    build_list = report(url, user, token, project=project_name,
                        action='builds')
    for record in build_list:
        data.append(json.loads(record, object_hook=from_json))
    return data


def get_checkers(url, user, token, project_name):

    def from_json(json_object):
        return View(json_object)

    data = []
    checkers = report(url, user, token, project=project_name,
                      action='defect_types')
    for c in checkers:
        data.append(json.loads(c, object_hook=from_json))
    return data


def write_line(file, issue):
    spacing = ',,,,,,'
    file.write(str(issue.id) + ',' +
               issue.code + ',' +
               issue.name + ',' +
               issue.location + ',' +
               issue.build + ',' +
               issue.severity + ',' +
               issue.status + ',' +
               issue.owner.replace(',', '') + ',')

    if not issue.history:
        file.write('\n')
        return 0

    idx = 0
    for hist in issue.history:
        for h in hist:
            comment = h.get('comment', '').encode('ascii', 'ignore')
            owner = h.get('owner', '').replace(',', '')
            status = h.get('status', '')

            if comment is None:
                file.write('\n')
                continue
            else:
                comment = comment.encode('utf-8') \
                    .replace(',', '').replace('\n', '').strip()

            if idx == 0:
                file.write(comment + '\n')
            elif 'status' in h:
                status = h['status']
                file.write(spacing + status + ',' +
                           owner + ',' + comment + '\n')
            else:
                file.write(spacing + ',' + owner + ',' + comment + '\n')

            idx += 1


class Details(object):
    def __init__(self, attrs):
        for attr in attrs:
            setattr(self, attr, attrs[attr])
        self.history = []
        if 'history' in attrs:
            self.history.append(attrs['history'])


class Build(object):
    def __init__(self, attrs):
        self.id = attrs['id']
        self.name = attrs['name']
        self.date = time.ctime(attrs['date'] / 1000)
        self.keepit = attrs['keepit']


class View(object):
    def __init__(self, attrs):
        for attr in attrs:
            setattr(self, attr, attrs[attr])
        # self.code = attrs['code']
        # self.name = attrs['name']
        # self.enabled = attrs['enabled']
        # self.severity = attrs['severity']


def main():
    project, issue_search, show_builds, show_checkers = parse_args()
    token = get_token(token_file)
    project_list = report(url, user, token, action='projects')
    project_info = get_project(project_list, project)
    project_name = project_info.get('name', None)
    project_id = project_info.get('id', None)
    print 'Project Name: %s' % project_name
    print 'Project ID: %s' % project_id

    # Add trailing slash to output dir and project subdir
    if not show_builds:
        output_path = os.path.join(os.path.join(output_dest, '') + project, '')
        gen_dirs(output_path)

    # List builds if build argument was called
    if show_builds:
        builds = get_builds(url, user, token, project_name)
        print 'ID\tNAME\t\tDATE\t\t\t\tKEEPIT'
        for b in builds:
            print '%s\t%s\t%s\t%s' % (b.id, b.name, b.date, b.keepit)
        raise SystemExit

    # List checkers if checker arguement was called
    if show_checkers:
        filename = output_path + 'checkers.csv'
        checkers = get_checkers(url, user, token, project_name)
        with open(filename, 'w') as file:
            file.write('Code,Name,Enabled,Severity\n')
            for c in checkers:
                code = c.code
                name = "'" + c.name.replace(',', '') + "'"
                enabled = c.enabled
                severity = c.severity
                file.write(code + ',' + name + ',' + 
                           str(enabled) + ',' + str(severity) + '\n')
        raise SystemExit

    # List issues if issue argument was called
    if issue_search == 'open':
        issues = get_issues_open(url, user, token, project_name)
        filename = output_path + 'open_issues.csv'
    elif issue_search == 'reconciled':
        issues = get_issues_reconciled(url, user, token, project_name)
        filename = output_path + 'reconciled_issues.csv'

    issue_list = list(issues)
    count = len(issue_list)
    print 'Retrieving %s issues...' % count
    print 'Estimated run time: %s minutes' % round(((count * 0.57) / 60), 1)

    response_times = []
    time_start = time.time()
    with open(filename, 'w') as file:
        file.write('ID,Code,Name,Location,Build,'
                   'Severity,Status,Owner,Comments\n')
        for i in issue_list:
            item = json.loads(i)
            response_time_start = time.time()
            details = get_issue_details(url, user, token,
                                        project_name, item['id'])
            response_time_stop = time.time()
            response_times.append(response_time_stop - response_time_start)
            for detail in details:
                issue = Details(json.loads(detail))
                print issue.id
                write_line(file, issue)
    time_stop = time.time()
    time_total = round((time_stop - time_start), 2)
    print 'Time Elapsed: %s seconds (%s minutes)' % \
        (time_total, str(round((time_total / 60), 2)))
    print 'Average response time: %s seconds' % avg_response(response_times)


if __name__ == '__main__':
    port = 443
    host = 'bullwhip.physio-control.com'
    url = 'https://%s:%d/review/api' % (host, port)
    user = 'john.arnett'
    token_file = './ltoken'
    output_dest = 'output'
    main()
