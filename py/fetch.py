#!/usr/bin/env python2.7
"""Fetch all necessary repos.
"""
import argparse
import logging
import os
import sys
import urlparse
LOG = logging.getLogger(__name__)
MY_GIT_URL = os.environ.get('MY_GIT_URL', 'ssh://git@bitbucket.nanofluidics.com:7999/sat/falcon-test')

def system(cmd):
    LOG.info(cmd)
    return os.system(cmd)
def unchecked_system(cmd):
    rc = system(cmd)
    if rc:
        LOG.debug('{!r} <- {!r}'.format(rc, cmd))
def checked_system(cmd):
    rc = system(cmd)
    if rc:
        raise Exception('{!r} <- {!r}'.format(rc, cmd))
def clone_repo(url, path):
    if not os.path.isdir(path):
        system('git clone {} {}'.format(url, path))
def fetch_repo(path, branch, remote, system=checked_system):
    system('git -C {} fetch {} {}'.format(path, remote, branch))
def checkout_repo(path, branch, system=checked_system):
    system('git -C {} checkout {}'.format(path, branch))
def report_repo(path, system=checked_system):
    system('git -C {} rev-parse HEAD'.format(path))
def fetch(repos, branch, git_server, directory, update):
    for repo in repos:
        url = '{}/{}'.format(git_server, repo)
        path = os.path.join(directory, os.path.basename(repo))
        clone_repo(url, path)
    if update:
        for repo in repos:
            path = os.path.join(directory, os.path.basename(repo))
            remote = 'origin' # by assumption
            fetch_repo(path, branch, remote, system=unchecked_system)
    for repo in repos:
        path = os.path.join(directory, os.path.basename(repo))
        checkout_repo(path, branch, system=unchecked_system)
        report_repo(path)
def parse_url(url):
    parsed = urlparse.urlparse(url)
    LOG.info('{!r} -> {!r}'.format(url, parsed))
    return '{}://{}'.format(*parsed[:2])
def main(args=sys.argv):
    default_git_server = parse_url(MY_GIT_URL)
    default_repos = ['sat/FALCON', 'sat/pypeFLOW', 'sat/daligner', 'sat/dextractor', 'sat/damasker', 'sat/dazz-db']
    #default_repos = ['sat/pypeFLOW']
    description = 'Fetch FALCON, pypeFLOW.'
    parser = argparse.ArgumentParser(
        description,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument('--branch', default='master',
        help='All repos will be checked out on this branch. However, if that branch is not found for a given repo, the current HEAD is used.')
    parser.add_argument('--repos', nargs='*', default=default_repos, metavar='REPO',
        help='Fetch these repos.')
    parser.add_argument('--git-server', default=default_git_server,
        help='Fetch repos from SERVER/NAME')
    parser.add_argument('--directory', default='.',
        help='Directory for repos.')
    parser.add_argument('--update', '-u', action='store_true',
        help='Whether to update repos which have already been cloned.')
    parsed = parser.parse_args(args[1:])
    LOG.info(repr(parsed))
    fetch(**vars(parsed))

if __name__=="__main__":
    logging.basicConfig()
    LOG.setLevel(logging.INFO)
    main()
