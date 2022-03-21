#from app import app
from flask import Flask, render_template

app = Flask(__name__)


@app.route('/admin/home')
def admin_home():
	return "Admin Home"

if __name__ == '__main__':
	app.run()
