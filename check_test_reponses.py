# from unittest import TestResult
from email.policy import default
from models.qa_models import CounsellingSuggestion, TestResult, Test,ConsultationRequest
from models.disease_models import TestResultDisease, PsychiatristDisease ,Disease
from models.models import Person
from flask import request
import jwt
from app import app,db
from check_test_reponses_controller import *
from authentication_controller import psychiatrist_token_required, patient_token_required
from datetime import datetime
import random

@app.route('/test_responses')
@psychiatrist_token_required
def test_responses(_):
    # print('efewgew00')
    return jsonify({'results' : fetch_test_responses()})


@app.route('/submit_review_report/<int:test_response_id>', methods=['POST'])
@psychiatrist_token_required
def submit_response(_, test_response_id):
    # print(request.json)
    # #insert comment into test result table
    #Psy Suggestions to be placed here
    psy_suggestions = []

    #Update Comment , Verified Date, Verified By
    test_result = TestResult.query.filter_by(test_result_id=test_response_id).first()
    test_result.manual_report = request.json['comment']
    test_result.verifier_id = request.json['verifier_id']
    test_result.verified_at = datetime.now()

    #Add Suggested Diagnosis & Find corresponding Expert
    for disease in request.json["disorder"]:
        if request.json["disorder"][disease] == True :
            disease_id = Disease.query.filter_by(name=disease).first().disease_id
            stmt = TestResultDisease.insert().values(test_result_id=test_response_id, disease_id=disease_id)
            db.session.execute(stmt)
            psy_suggestions += [(x[1].person_id, x[1].name) for x in db.session.query(PsychiatristDisease, Person)\
                                            .join(Person, Person.person_id == PsychiatristDisease.psychiatrist_id)\
                                            .filter(PsychiatristDisease.disease_id == disease_id).all()]

    #Randomly Choose 3 Psychiatrists; if there are less than 3, then use all of them
    if len(psy_suggestions) > 3:
        psy_suggestions = random.sample(psy_suggestions,3)

    #Add Suggested Psychiatrists to Counselling Suggestion Table
    for idx, _ in psy_suggestions:
        stmt = CounsellingSuggestion.insert().values(test_result_id=test_response_id, psychiatrist_id=idx)
        db.session.execute(stmt)
    db.session.commit()

    return jsonify({"response" :'success'})


# @patient_token_required
# def view_verified_report(_,patient):
#     

@app.route('/view_verified_report/', methods=['GET'])
@app.route('/view_verified_report/<int:test_response_id>', methods=['GET'])
@patient_token_required
def view_verified_report(_,test_response_id = None):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    #Base URL
    if test_response_id is None:
    
        #Filter the Verified Results
        test_result = db.session.query(TestResult, Test, Person).join(Test, TestResult.test_id == Test.test_id)\
                                                                .join(Person, Person.person_id == TestResult.verifier_id)\
                                                                .filter(TestResult.patient_id == data['patient_id']).all()

        #Get Psychiatrist Suggestions
        psy_suggestions = db.session.query(CounsellingSuggestion, Person)\
                                .join(Person, CounsellingSuggestion.c.psychiatrist_id == Person.person_id).all()

        #Last item is the Person Object
        psy_suggestions = [{"psychiatrist_id" : x[-1].person_id, "name" : x[-1].name } for x in psy_suggestions]

        # index 0 is TestResult , 1 is Test, and so on
        return jsonify({"verified_reports": [{"reportId" : x[0].test_result_id, "test_name" : x[1].name, 
                                            "submitted_at" : x[0].submitted_at, "verified_at" : x[0].verified_at
                                            , "psychiatrist" : x[2].name,
                                            "manual_report" : x[0].manual_report, "systemScore": x[0].score,
                                             "suggestedPsychiatrists": psy_suggestions } for x in test_result]})
    else:
        test_result = TestResult.query.filter_by(test_result_id=test_response_id).first()
        try:
            if test_result.patient_id == data['patient_id']:
                return fetch_patient_responses(test_response_id)
            else:
                return jsonify({"error" : "You are not authorized to view this report"})
        except:
            return jsonify({"error" : "ERRRORRRRRR You are not authorized to view this report"})


@app.route('/send_consultation_request/', methods=['POST'])
@patient_token_required
def send_consultation_request(_):
    #insert consultation request in table
    consultation_request = ConsultationRequest(counsel_id = request.json['counsel_id'], test_result_id = request.json['test_result_id'],
                                             info = request.json['info'], schedule = request.json['schedule'], method = request.json['method'],
                                             fee = request.json['fee'])
    db.session.add(consultation_request)
    db.session.commit()
    return jsonify({"response" :'success'})


@app.route('/view_consultation_request/', methods=['GET'])
@psychiatrist_token_required
def view_consultation_request(_):

    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    #get all consultation requests for this psychiatrist
    consultation_requests = db.session.query(ConsultationRequest, CounsellingSuggestion)\
                                .join(CounsellingSuggestion, CounsellingSuggestion.c.counsel_id == ConsultationRequest.counsel_id)\
                                .filter(CounsellingSuggestion.c.psychiatrist_id == data['psychiatrist_id']).all()
    
    return jsonify({"consultation_requests": [{"requestId" : x[0].consultation_request_id, 
                                            "schedule" : x[0].schedule, "method" : x[0].method, "fee" : x[0].fee,
                                            "info" : x[0].info} for x in consultation_requests]})

@app.route('/accept_consultation_request/<int:consultation_id>', methods=['POST'])
@psychiatrist_token_required
def accept_consultation_request(_,consultation_id):
    #update consultation request
    consultation_request = ConsultationRequest.query.filter_by(consultation_request_id = consultation_id).first()
    consultation_request.approved = True
    db.session.commit()
    return jsonify({"response" :'success'})

@app.route('/view_accepted_consultation_request/', methods=['GET'])
@patient_token_required
def view_accepted_consultation_request(_):
    #get all consultation requests for this patient
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    consultation_requests = db.session.query(ConsultationRequest, TestResult, Person)\
                                .join(TestResult, ConsultationRequest.test_result_id == TestResult.test_result_id)\
                                .join(Person, Person.person_id == TestResult.patient_id)\
                                .filter(Person.person_id == data['patient_id']).all()
    
    return jsonify({"consultation_requests": [{"requestId" : x[0].consultation_request_id, 
                                            "schedule" : x[0].schedule, "method" : x[0].method, "fee" : x[0].fee,
                                            "info" : x[0].info} for x in consultation_requests]})

