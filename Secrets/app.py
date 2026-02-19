import os
from flask import Flask, render_template
import mysql.connector

app = Flask(__name__)

def fetch_color():
    """Fetch color from environment variable or return default"""
    return os.getenv('APP_COLOR', 'blue')

@app.route('/')
def main():
    # Get database credentials from environment variables (secrets)
    db_host = os.getenv('DB_HOST', 'mysql')
    db_user = os.getenv('DB_USER', 'root')
    db_password = os.getenv('DB_PASSWORD', 'passwd')
    db_name = os.getenv('DB_NAME', 'mydb')
    
    try:
        # Connect to MySQL database
        connection = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        connection.close()
        db_status = "Connected"
    except Exception as e:
        db_status = f"Connection failed: {str(e)}"
    
    color = fetch_color()
    return render_template('index.html', color=color, db_status=db_status)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)