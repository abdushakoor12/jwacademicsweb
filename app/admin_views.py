from app import app
from flask import render_template

@app.route('/admin/home')
def admin_home():
	return "Admin Home"