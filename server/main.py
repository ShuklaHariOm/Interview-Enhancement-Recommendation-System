from flask import Flask, request, jsonify
import bcrypt
from flask_cors import CORS
import sqlite3
import jwt
from datetime import datetime, timezone, timedelta
import pandas as pd

app = Flask(__name__)
CORS(app, supports_credentials=True)
JWT_SECRET_KEY = 'abcdef#$%^'
JWT_ALGORITHM = 'HS256'
JWT_EXPIRATION_DELTA = timedelta(days=1)

dataset = pd.read_csv('dataset.csv')

def generate_token(user_id):
    payload = {
        'user_id': user_id,
        'exp': datetime.now(timezone.utc) + JWT_EXPIRATION_DELTA
    }
    try:
        token = jwt.encode(payload, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)
        # print("Token generated successfully:", token)
        return token
    except jwt.PyJWTError as e:
        print("Error generating token:", e)
        return None

def verify_token(token):
    try:
        payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=[JWT_ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None
    
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    confirm_password = data.get('confirm_password')
    if password != confirm_password:
        return jsonify({'error': 'Passwords do not match'}), 400
    
    salt_rounds = 12
    salt = bcrypt.gensalt(rounds=salt_rounds)
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)

    try:
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO users (name, email, password, salt)
            VALUES (?, ?, ?, ?)
        ''', (name, email, hashed_password, salt.decode('utf-8')))
        conn.commit()
    except sqlite3.IntegrityError as e:
        if 'UNIQUE constraint failed' in str(e):
            return jsonify({'error': 'Email is already in use'}), 409
        else:
            return jsonify({'error': 'An error occurred while processing your request'}), 500
    finally:
        if conn:
            conn.close()

    return jsonify({'message': 'User signed up successfully'}), 200

@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')

        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM users WHERE email = ?', (email,))
        user = cursor.fetchone()

        if user:
            stored_salt = user[4]
            hashed_password = bcrypt.hashpw(password.encode('utf-8'), stored_salt.encode('utf-8'))

            if hashed_password == user[3]:
                user_id = user[0]
                token = generate_token(user_id)
                return jsonify({'message': 'Login successful', 'token': token}), 200
            else:
                return jsonify({'error': 'Invalid email or password'}), 401
        else:
            return jsonify({'error': 'User not found'}), 404
    except jwt.ExpiredSignatureError:
        return jsonify({'error': 'Expired token'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'error': 'Invalid token'}), 401
    except Exception as e:
        print(e)
        return jsonify({'error': 'An error occurred while processing your request'}), 500
    finally:
        if conn:
            conn.close()

@app.route('/check_login', methods=['GET'])
def check_login():
    token = request.headers.get('Authorization')
    print(token)
    if token:
        token = token.split(' ')[1]
        payload = verify_token(token)
        if payload:
            user_id = payload.get('user_id')
            print('User ID:', user_id)
            return jsonify({'logged_in': True}), 200
    return jsonify({'logged_in': False}), 200

@app.route('/subjects')
def get_subjects():
    subjects = dataset['Domain'].unique()
    return jsonify(subjects.tolist())

if __name__ == '__main__':
    app.run(debug=True)
