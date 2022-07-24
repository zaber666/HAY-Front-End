import datetime
from datetime import timedelta
from functools import wraps
from werkzeug.security import generate_password_hash

import jwt
from flask import request, jsonify, make_response
from werkzeug.security import check_password_hash

from app import app, db
from models import Person, Patient, Psychiatrist


def generic_token_required(user_type, f):
    @wraps(f)
    def generic_decorator(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
            print('Token in generic decorator', token)
        if not token:
            print('Token is missing', user_type)
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            # print('PRINTING DATA')
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            # print('PRINTING DATA 2')
            print(data)
            if user_type == 'Person':
                current_user = Person.query.filter_by(person_id=data['person_id']).first()
            elif user_type == 'Patient':
                current_user = Patient.query.filter_by(patient_id=data['patient_id']).first()
            elif user_type == 'Psychiatrist':
                # print('PRINTING DATA 3')
                current_user = Psychiatrist.query.filter_by(psychiatrist_id=data['psychiatrist_id']).first()
                # print(current_user)
        except:
            print('Token is invalid for', user_type)
            return jsonify({'message': 'Token is invalid!'}), 401
        print('Returning')
        return f(current_user, *args, **kwargs)
    return generic_decorator


token_required = lambda f : generic_token_required('Person', f)
patient_token_required = lambda f : generic_token_required('Patient', f)
psychiatrist_token_required = lambda f : generic_token_required('Psychiatrist', f)


@app.route('/logout', methods=['GET', 'POST'])
@token_required
def generic_logout():
    jwt.encode(dict())


def generic_login(user_type, auth):
    global id_name
    if not auth or not auth.get('email') or not auth.get('password'):
        return make_response('Could not verify', 401, {'Authenticate': "Login required!"})
    user = Person.query.filter_by(email=auth.get('email')).first()
    if user_type == 'Person':
        id_name = 'person_id'
    elif user_type == 'Patient':
        id_name = 'patient_id'
    elif user_type == 'Psychiatrist':
        id_name = 'psychiatrist_id'
    if user is not None and check_password_hash(user.password_hash, auth.get('password')):
        token = jwt.encode({id_name: user.person_id, 'exp': datetime.utcnow() + timedelta(minutes=60)},
                           app.config['SECRET_KEY'])
        return make_response(jsonify({'token': token}, {'id_name': id_name}, {'person_id': user.person_id}
                                        , {'name': user.name}), 201)
    return make_response('Could not verify', 403, {'Authenticate': "Login required!"})


def patient_signup_control(_id, _request):
    data = _request.get_json(force=True)
    name, email = data.get('name'), data.get('email_')
    password = data.get('password_')
    dob = data.get('dob')
    gender = data.get('gender')[0]
    user = Person.query.filter_by(email=email).first()

    if not user:
        if _id == 1:
            height_inches = data.get('height')
            weight_kgs = data.get('weight')
            location = data.get('location')
            patient = Patient(
                height_inches=height_inches, weight_kgs = weight_kgs, location = location, date_of_birth = dob,
                gender = gender, photo_path = 'https://picsum.photos/200',
                name=name, email=email, password_hash=generate_password_hash(password))
            db.session.add(patient)
        elif _id == 2:
            certificateId = data.get('certificateId')
            psychiatrist = Psychiatrist(
                certificate_id = certificateId, date_of_birth = dob, gender = gender, photo_path = 'https://picsum.photos/200'
                , name = name, email = email, password_hash = generate_password_hash(password))
            db.session.add(psychiatrist)
        db.session.commit()
        return make_response('Successfully registered.', 201)
    else:
        return make_response('User already exists. Please Log in.', 202)