FROM ubuntu

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# Install Flask and Flask-mysql
RUN pip3 install --break-system-packages flask flask-mysql

COPY . /opt/source-code

ENTRYPOINT ["sh", "-c", "FLASK_APP=/opt/source-code/app.py flask run"]
