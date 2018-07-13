# Generate GitLab user list

import requests
import json

file = 'git_users.txt'
token = 'xxxxxxxxxxxxxxxxxxxx'
url = 'https://<gitlab_server>/api/v4/users?per_page=100'
headers = {'Private-Token': token}


def getTotalPages(header_links):
    pages = []
    start_idx = 0
    while True:
        f = links.find('&page=', start_idx)
        if f < 0:
            break
        else:
            pages.append(f)
            start_idx = f + 1
    last_idx = pages[-1]
    total_pages = links[last_idx + 6: last_idx + 7]
    return int(total_pages)


# MAIN
response = requests.get(url, headers=headers)
links = response.headers['Link']

total_pages = getTotalPages(links)
with open(file, 'w') as f:
    for i in range(1, total_pages + 1):
        url = url + '&page=' + str(i)
        r = requests.get(url, headers=headers)
        users = json.loads(r.text)
        for user in users:
            print user['email']
            f.write('{}\n'.format(user['email']))
