from app import app
import flask_restless
from models import *
from qa_models import *
from werkzeug.security import generate_password_hash, check_password_hash
from flask import Flask, jsonify, make_response, request
from functools import wraps
import jwt
from datetime import datetime, timedelta
import uuid

# Create the Flask-Restless API manager.
# manager = flask_restless.APIManager(session=db.session)
# person_blueprint = manager.create_api(Person, methods=['GET', 'POST'])
# manager.init_app(app)


app.config['SECRET_KEY'] = 'HahaNoSecret'
def token_required(f):
    @wraps(f)
    def decorator(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            print('PRINTING DATA')
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            print('PRINTING DATA 2')
            print(data)
            current_user = Person.query.filter_by(person_id=data['person_id']).first()
        except:
            return jsonify({'message': 'Token is invalid!'})
        return f(current_user, *args, **kwargs)
    return decorator

@app.route('/user', methods = ['GET'])
@token_required
def get_all_users(current_user):
    users = Person.query.all()
    output = []
    for user in users:
        output.append({
            'public_id' : user.person_id,
            'name': user.name,
            'email':user.email
        })
    return jsonify({'users': output})

@app.route('/login', methods=['POST'])
def login():
    auth = request.form
    if not auth or not auth.get('email') or not auth.get('password'):
        return make_response('Could not verify', 401, {'Authenticate': "Login required!"})
    user = Person.query.filter_by(email=auth.get('email')).first()
    if check_password_hash(user.password_hash, auth.get('password')):
        token = jwt.encode({'person_id': user.person_id, 'exp': datetime.utcnow() + timedelta(minutes=60)}, app.config['SECRET_KEY'])
        return make_response(jsonify({'token' : token}), 201)
    return make_response('Could not verify', 403, {'Authenticate': "Login required!"})


@app.route('/signup', methods=['POST'])
def signup():
    data = request.form
    name, email = data.get('name'), data.get('email')
    password = data.get('password')

    user = Person.query.filter_by(email=email).first()
    if not user:
        user = Person(
                        name=name,
                        email = email,
                        password_hash = generate_password_hash(password))

        db.session.add(user)
        db.session.commit()
        return make_response('Succesfully registered.', 201)
    else:
        return make_response('User already exists. Please Log in.', 202)

app.run(debug=True,host='0.0.0.0')