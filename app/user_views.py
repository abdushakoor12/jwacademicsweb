#from app import app
from flask import Flask, render_template


app = Flask(__name__)

@app.route('/user/home')
def user_home():
	return "Welcome User"


if __name__ == '__main__':
	app.run()
