from app import app
from flask import render_template

@app.route('/user/home')
def user_home():
	return "Welcome User"