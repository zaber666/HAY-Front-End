import jwt

from app import app, db
from authentication_controller import psychiatrist_token_required
from flask import request
from models.export import *
from datetime import datetime


@app.route('/cfr', methods=['POST'])
@psychiatrist_token_required
def create_file_request(_):
    token = request.headers['x-access-token']
    token_data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    data = request.get_json()
    file_request = FileRequest(
        created_at = datetime.now(),
        title = data['title'],
        description = data['desc'],
        psychiatrist_id = token_data['psychiatrist_id']
    )
    db.session.add(file_request)
    db.session.commit()
    return "File request created!"
