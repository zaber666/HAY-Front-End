from flask import request

from app import app
from check_test_reponses_controller import *
from authentication_controller import psychiatrist_token_required


@app.route('/test_responses')
@psychiatrist_token_required
def test_responses(_):
    print('efewgew00')
    return jsonify({'results' : fetch_test_responses()})


@app.route('/submit_comment/<int:test_response_id>', methods=['POST'])
@psychiatrist_token_required
def submit_comment(_, test_response_id):
    print(request.json)
    return 'ok'


@app.route('/disorder_suggestions/<int:test_response_id>', methods=['POST'])
@psychiatrist_token_required
def disorder_suggestions(_, test_response_id):
    print(request.json)
    return 'ok'