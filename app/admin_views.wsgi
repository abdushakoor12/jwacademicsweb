import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/var/www/html/jwacademicsweb/app')

#from views import app as application
from admin_views import app as application
#from user_views import app as application
#from writer_views import app as application
