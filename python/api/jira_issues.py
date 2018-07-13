#!/usr/bin/env python


'''
Pulls all issues from JIRA by project and outputs them to csv files in:
./output/
    - open_issues.csv
    - closed_issues.csv

Third Party Libraries Required:
jira-python : https://jira.readthedocs.io/en/master/

Author: John Arnett
Version: Python v2.7.14
'''


from getpass import getpass
from jira import JIRA
import codecs
import time
import sys


# Set Encoding to Unicode
sys.stdout = codecs.getwriter('utf8')(sys.stdout)
sys.stderr = codecs.getwriter('utf8')(sys.stderr)


# Defines JQL string for JIRA queries
def defineStatus(status):
    valid_status = {'open', 'closed'}
    if status not in valid_status:
        raise ValueError('issuesByProject: status must be %r.' % valid_status)
    elif status == 'open':
        jql = 'resolution = Unresolved AND project='
    else:
        jql = 'resolution in (Fixed, "Won\'t Fix", Duplicate, Incomplete, \
        "Cannot Reproduce", Defer, Done, "Won\'t Do", Dismiss) AND project='
    return jql


# Grab total number of open or closed issues by project
def totalIssuesByProject(project, status):
    project = "'" + project + "'"
    jql = defineStatus(status)
    issues = jira.search_issues(jql + project, json_result=True)
    return issues['total']


# Grab info for all open or closed issues by project
def issuesByProject(project, status):

    # Make sure total number of issues hasn't changed
    # since kicking off script (avoids endless loop)
    def checkLoop(last_loop, new_loop):
        if last_loop == new_loop:
            return True
        else:
            return False

    issues = []
    total = totalIssuesByProject(project, status)
    jql = defineStatus(status)
    project = "'" + project + "'"

    block_size = 100
    block_num = 0
    t_start = time.time()
    while True:
        last_loop = len(issues)
        start_idx = block_num * block_size
        t0 = time.time()
        req = jira.search_issues(jql + project, start_idx, block_size)
        t1 = time.time()
        req_time = t1 - t0
        print "Elapsed time: " + str(req_time) + " seconds"
        issues.extend(req)

        new_loop = len(issues)
        loop_check = checkLoop(last_loop, new_loop)

        if loop_check:
            break
        elif len(issues) < total:
            print(len(issues))
            block_num += 1
            continue
        else:
            break

    t_stop = time.time()
    total_time = t_stop - t_start
    print "Total time elapsed: " + str(total_time) + " seconds"
    return issues


# Write issue list to file
def writeToFile(issues, filename):
    w_start = time.time()
    print 'Writing open issues to file...'

    file = open('output/' + filename + '.csv', 'w')
    file.write('Issue ID,Issue Type,Components,Resolution,Summary\n')
    for i in range(len(issues)):
        issue_id = issues[i].id
        issue_type = str(issues[i].fields.issuetype)
        issue_summary = issues[i].fields.summary.replace(',', '').strip()

        if issues[i].fields.components:
            issue_comp = str(issues[i].fields.components[0])
        else:
            issue_comp = 'None'

        if issues[i].fields.resolution:
            issue_res = str(issues[i].fields.resolution)
        else:
            issue_res = 'None'

        file.write(issue_id + ',' + issue_type + ',' +
                   issue_comp + ',' + issue_res + ',')
        file.write(issue_summary.encode('utf-8') + '\n')

    file.close()
    w_stop = time.time()
    w_total = w_stop - w_start
    print 'Time to write to file: ' + str(w_total) + ' seconds'


# Main
# Define JIRA connection and options
username = input("Username: ")
password = getpass()
options = {'server': 'https://<jiar_server>'}
jira = JIRA(options, basic_auth=(username, password))

# Grab open TSP issues and write to file
open_issues = issuesByProject('<project_name>', 'open')
writeToFile(open_issues, 'open_issues')

# Grab closed TSP issues and write to file
closed_issues = issuesByProject('<project_name>', 'closed')
writeToFile(closed_issues, 'closed_issues')

# Print totals
total_open = totalIssuesByProject('<project_name>', 'open')
total_closed = totalIssuesByProject('<project_name>', 'closed')
print 'Total Open: ' + str(total_open)
print 'Total Closed: ' + str(total_closed)
# EOF
