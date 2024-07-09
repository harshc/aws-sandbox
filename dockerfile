# use a python base image from dockerhub
FROM python:3.11-slim

# Tags
LABEL maintainer="Harsh Chiplonkar<harsh@chiplonkar.me>"
LABEL version="1.0.0"
LABEL description="Simple Flask API for a AWS Demo"

# set the working directory
WORKDIR /app

# get the requirements.txt so we can install dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy the rest of the api over to the working directory
COPY app/ .

# open port 9000
EXPOSE 9000

#launch gunicorn with the configuration file
CMD ["gunicorn", "--config", "gunicorn.conf.py", "api:app"]