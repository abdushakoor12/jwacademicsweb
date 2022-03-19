#app.py
#Testing Flask Application

from flask import Flask
app = Flask(__name__)
@app.route('/jwacademicsweb')
def hello_world():
	return 'Hello from Flask!'

if __name__ == '__main__':
	app.run()
