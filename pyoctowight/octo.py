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

from flask import Flask
from flask import request, render_template

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

    fh, datafile = tempfile.mkstemp(prefix='ballinoctowight-', suffix='.pl')
    os.close(fh)
    with open(datafile, "w") as f:
        f.write(data)
    os.unlink(datafile)

    league_exec = os.path.join(BASEDIR, 'league.pl')
    winners = subprocess.check_output(
        [league_exec, datafile])
    json_winners = jsonify_prolog(winners)
    return json_winners


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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080,
            debug=DEBUG)
