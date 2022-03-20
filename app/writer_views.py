from app import app
from flask import render_template

@app.route('/writer/home')
def writer_home():
	return "Writer Home"