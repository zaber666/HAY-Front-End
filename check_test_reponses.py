# from unittest import TestResult
from email.policy import default
from models.qa_models import TestResult, Test
from models.disease_models import TestResultDisease, PsychiatristDisease ,Disease
from models.models import Person
from flask import request
import jwt
from app import app,db
from check_test_reponses_controller import *
from authentication_controller import psychiatrist_token_required, patient_token_required
from datetime import datetime

@app.route('/test_responses')
@psychiatrist_token_required
def test_responses(_):
    # print('efewgew00')
    return jsonify({'results' : fetch_test_responses()})


@app.route('/submit_review_report/<int:test_response_id>', methods=['POST'])
@psychiatrist_token_required
def submit_response(_, test_response_id):
    print(request.json)
    #insert comment into test result table
    psy_suggestions = []
    test_result = TestResult.query.filter_by(test_result_id=test_response_id).first()
    test_result.manual_report = request.json['comment']
    test_result.verifier_id = request.json['verifier_id']
    test_result.verified_at = datetime.now()
    for disease in request.json["disorder"]:
        if request.json["disorder"][disease] == True :
            disease_id = Disease.query.filter_by(name=disease).first().disease_id
            stmt = TestResultDisease.insert().values(test_result_id=test_response_id, disease_id=disease_id)
            db.session.execute(stmt)
            PsychiatristDisease.query.filter_by(disease_id = disease_id).all()
            
    db.session.commit()
    return jsonify({"response" :'success'})


# @patient_token_required
# def view_verified_report(_,patient):
#     

@app.route('/view_verified_report/', methods=['GET'])
@app.route('/view_verified_report/<int:test_response_id>', methods=['GET'])
@patient_token_required
def view_verified_report(_,test_response_id = None):
    if test_response_id is None:
        token = request.headers['x-access-token']
        data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
        test_result = db.session.query(TestResult, Test, Person).join(Test, TestResult.test_id == Test.test_id)\
                                                                .join(Person, Person.person_id == TestResult.verifier_id)\
                                                                .filter(TestResult.patient_id == data['patient_id']).all()
        # index 0 is TestResult , 1 is Test, and so on
        return jsonify({"verified_reports": [{"reportId" : x[0].test_result_id, "test_name" : x[1].name, 
                                            "submitted_at" : x[0].submitted_at, "verified_at" : x[0].verified_at
                                            , "psychiatrist" : x[2].name,
                                            "manual_report" : x[0].manual_report, "systemScore": x[0].score,
                                             "suggested_psychiatrists": [] } for x in test_result]})
    else:
        return fetch_patient_responses(test_response_id)


