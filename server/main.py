from flask import Flask, request, jsonify, session
import bcrypt
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)
app.secret_key = b'abcdefghi'

def is_logged_in():
    return 'user_id' in session

@app.route('/check_login', methods=['GET'])
def check_login():
    if is_logged_in():
        return jsonify({'logged_in': True}), 200
    else:
        return jsonify({'logged_in': False}), 200

@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    print(name)

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
                session['user_id'] = user[0]
                return jsonify({'message': 'Login successful'}), 200
            else:
                return jsonify({'error': 'Invalid email or password'}), 401
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        return jsonify({'error': 'An error occurred while processing your request'}), 500
    finally:
        if conn:
            conn.close()


@app.route('/logout', methods=['POST'])
def logout():
    session.pop('user_id', None)
    return jsonify({'message': 'Logout successful'}), 200

if __name__ == '__main__':
    app.run(debug=True)
