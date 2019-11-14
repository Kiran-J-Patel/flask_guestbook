from flask import request
from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, SubmitField
from wtforms.validators import DataRequired

class PostForm(FlaskForm):
    author = StringField('Name', validators=[DataRequired()])
    post = TextAreaField('Type your message here...', validators=[DataRequired()])
    submit = SubmitField('Submit')