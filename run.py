from app import *
from authentication import *
from take_questionnaire import *
import flask_restless



def is_patient_logged_in(_ = None, **kwargs):

    @patient_token_required
    def internal():
        print('It came inside internal')
        return True

    print('Outside internal')
    try:
        if internal()[1] == 401:
            print('Internal completed without error. Should raise exception.')
            ex = True
    except:
        print('In except')
        ex = False
    if ex:
        raise flask_restless.ProcessingException(detail='Not signed up as patient', status=401)



# Create the Flask-Restless API manager.
manager = flask_restless.APIManager(session=db.session, preprocessors={'GET_COLLECTION':[is_patient_logged_in]
                    , 'GET_RESOURCE':[is_patient_logged_in], 'POST_RESOURCE':[is_patient_logged_in]})
person_blueprint = manager.create_api(Person, methods=['GET', 'POST'], exclude=['password_hash'])
manager.create_api(Option, methods=['GET'])
manager.create_api(Test, methods=['GET', 'POST'])
manager.create_api(Question, methods=['GET', 'POST'])
manager.create_api(TestResult, methods=['GET', 'POST', 'PATCH'], collection_name='tr')

manager.init_app(app)

db.create_all()
app.run(debug=True, host='0.0.0.0')
