"""Ballin Octo Wight
The name says it all.
"""

DEBUG=True
BASEDIR='/Users/rbp/hyves/hackathon/Jun2012/ballin-octo-wight'


import os
import subprocess
import json
import re
import tempfile
from contextlib import contextmanager

from flask import Flask
from flask import request, render_template, url_for

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/group_phase', methods=['POST'])
def group_phase():
    leagues = request.json['leagues']
    matches = request.json['matches']
    all_leagues = [leagues[group] for group in sorted(leagues)]
    matches_played = [
        "match_played({}, {}, {}, {}).".format(match['team1'].lower(), match['team2'].lower(),
                                               match['score1'], match['score2'])
        for match in matches]
    data = """leagues({}).
    {}
    """.format(prologify_json(json.dumps(all_leagues)),
               "\n".join(matches_played))

    first_knockout = call_prolog('ek.pl', 'decide_group_phase', data)

    json_knockout = jsonify_prolog(first_knockout)
    r = {'winners': json.loads(json_knockout),
         'next_url': url_for('knockout_round')}
    json_response = json.dumps(r)
    return json_response

@app.route('/knockout_round', methods=['POST'])
def knockout_round():
    matches = request.json['matches']

    round = [[match['team1'], match['team2']] for match in matches]
    matches_played = [
        "match_played({}, {}, {}, {}).".format(match['team1'].lower(), match['team2'].lower(),
                                               match['score1'], match['score2'])
        for match in matches]
    data = """round({}).
    {}
    """.format(prologify_json(json.dumps(round)),
               "\n".join(matches_played))

    next_round = call_prolog('ek.pl', 'decide_next_knockout_round', data)

    json_next = jsonify_prolog(next_round)
    winners = json.loads(json_next)
    r = {'next_url': url_for('knockout_round')}
    if isinstance(winners, basestring):
        r['winner'] = winners
    else:
        r['winners'] = winners
    json_response = json.dumps(r)
    return json_response


def jsonify_prolog(string):
    '''Makes a prolog output string valid JSON'''
    # [[d,b],[h,f],[l,j],[p,n]] -> [["d","b"],["h","f"],["l","j"],["p","n"]]
    json_string = re.sub(r'\b(\w+)\b', r'"\1"', string, flags=re.I)
    return json_string

def prologify_json(string):
    '''Makes a JSON string valid prolog'''
    # [["D","B"],["H","F"],["L","J"],["P","N"]] -> [[d,b],[h,f],[l,j],[p,n]]
    prolog_string = re.sub(r'"(\w+)"', lambda m: m.group(1).lower(), string, flags=re.I)
    return prolog_string


def call_prolog(filename, goal, data):
    fh, datafile = tempfile.mkstemp(prefix='ballinoctowight-', suffix='.pl')
    os.close(fh)
    with open(datafile, "w") as f:
        f.write(data)

    with cd(BASEDIR):
        cmdline = 'swipl -q -t {} -s {} -- {}'.format(
            goal, filename, datafile).split()
        result = subprocess.check_output(cmdline)
    os.unlink(datafile)
    return result

@contextmanager
def cd(directory):
    original_dir = os.getcwd()
    if not original_dir.endswith(directory):
        os.chdir(directory)
    try:
        yield
    finally:
        os.chdir(original_dir)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080,
            debug=DEBUG)
