from app import app
from flask import render_template

@app.route('/staff/home')
def staff_home():
	return "Staff Home"