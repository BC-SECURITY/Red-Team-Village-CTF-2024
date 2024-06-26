from flask import Flask, request, render_template, redirect, url_for, session
import base64

app = Flask(__name__)
app.secret_key = 'super_secret_key'

# Mock database
users = {
    'admin': 'password',
    'user1': 'pass123'
}

# Encryption functions
def xor_encrypt_decrypt(message, key):
    return ''.join(chr(ord(c) ^ ord(k)) for c, k in zip(message, key * (len(message) // len(key) + 1)))

def encrypt_message(message, key):
    encrypted = xor_encrypt_decrypt(message, key)
    return base64.b64encode(encrypted.encode()).decode()

def decrypt_message(encrypted_message, key):
    decoded = base64.b64decode(encrypted_message).decode()
    return xor_encrypt_decrypt(decoded, key)

# Example encrypted messages
encrypted_messages = [
    {
        'id': 1,
        'content': encrypt_message('flag{something something}', 'covenant')
    },
    {
        'id': 2,
        'content': encrypt_message('WARNING: Covenant Infiltration Detected!', 'covenant')
    }
    # Add more encrypted messages here if needed
]

# Mock function to simulate a database query
def execute_query(query):
    for user, password in users.items():
        if f"'{user}'" in query and f"'{password}'" in query:
            return True
    return False

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    # Vulnerable SQL query
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    if execute_query(query):
        session['logged_in'] = True
        return redirect(url_for('show_messages'))
    else:
        return render_template('login_failed.html')

@app.route('/messages')
def show_messages():
    if not session.get('logged_in'):
        return redirect(url_for('index'))
    return render_template('messages.html', messages=encrypted_messages)

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('index'))

@app.route('/key-hint')
def key_hint():
    return render_template('key_hint.html')

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=80)
