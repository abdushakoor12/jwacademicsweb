#from app import app
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/writer/home')
def writer_home():
	return "Writer Home"

if __name__ == '__main__':
	app.run()
