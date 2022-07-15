from werkzeug.security import generate_password_hash, check_password_hash
from flask import Flask, jsonify, make_response, request
from flask_sqlalchemy import SQLAlchemy
from functools import wraps
from flask_migrate import Migrate
from flask_cors import CORS
# from flask_restful import Api
from datetime import datetime
import uuid
import jwt




app = Flask(__name__)
# set app config uri to postgres
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@db/mhst'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'HahaNoSecret'

db = SQLAlchemy(app)
migrate = Migrate(app, db)
cors = CORS(app)

# Create the database tables.
# db.create_all()


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'


# delete later

# Route for seeing a data
@app.route('/data')
def get_time():
    # Returning an api for showing in  reactjs
    return {
        'Name': "geek",
        "Age": "22",
        "Date": 10,
        "programming": "python"
    }



# #API
# api = Api(app)
# api.add_resource(Login, '/login')
# api.add_resource(Register, '/register')
# api.add_resource(Logout, '/logout')


# class Login(Resource):
#     def post(self):
#         # get the post data
#         post_data = request.get_json()
#         # get the data from the post data
#         username = post_data.get('username')
#         password = post_data.get('password')
#         # find user in the database
#         user = User.query.filter_by(username=username).first()
#         # check if the user exists
#         if not user:
#             return jsonify({'message': 'User does not exist.'})
#         # check if the password is correct
#         if user.password != password:
#             return jsonify({'message': 'Password is incorrect.'})
#         # generate the auth token
#         auth_token = user.encode_auth_token(user.id)
#         # return the auth token
#         return jsonify({'auth_token': auth_token.decode()})




if __name__ == '__main__':
    print('Type', type(app))
    app.run()
