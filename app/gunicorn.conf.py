# gunicorn conf
# sending gunicorn logs to stdout so docker can handle the log management
bind = "0.0.0.0:9000"
accesslog = "-"
errorlog = "-"
loglevel = "info"
workers = 3
timeout = 120
