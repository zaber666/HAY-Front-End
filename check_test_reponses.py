from app import app
from check_test_reponses_controller import *


@app.route('/test_responses')
def test_responses():
    return jsonify({'results' : fetch_test_responses()})

