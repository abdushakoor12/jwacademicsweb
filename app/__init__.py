from flask import Flask

app = Flask(__name__)

from app import views
from app import admin_views
from app import staff_views
from app import writer_views
from app import user_views