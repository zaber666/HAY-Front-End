from app import app
from authentication import *
import flask_restless


# Create the Flask-Restless API manager.
manager = flask_restless.APIManager(session=db.session)
person_blueprint = manager.create_api(Person, methods=['GET', 'POST'])

manager.init_app(app)


app.run(debug=True, host='0.0.0.0')
