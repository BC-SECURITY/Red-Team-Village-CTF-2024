from flask import Flask, request, render_template, redirect, url_for, session, Response
import base64
import random
import string
import time

app = Flask(__name__)
app.secret_key = 'super_secret_key'
key = 'Covenant#1'
flag = 'flag{c533655a69aebaecd2340d54fe599682}'

# Mock database
users = {
    'spartan': 'cortana',
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
        'content': encrypt_message('flag{babc9b8b4405d67cf28d58fe56ef96ccg}', key)
    },
    {
        'id': 2,
        'content': encrypt_message('WARNING: Covenant Infiltration Detected!', key)
    }
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

@app.route('/forgot_password')
def corrupted_endpoint():
    hint = "Hint: Username is 'spartan' and the password is related to the Master Chief's AI companion."
    corrupted_hint = ''.join(random.choice((str.upper, str.lower))(char) if char.isalpha() else char for char in hint)
    # Add random characters and noise
    noise = ''.join(random.choices('!@#$%^&*()_+[]{}|;:,.<>?', k=len(hint) // 2))
    corrupted_with_noise = ''.join(c + random.choice(noise) if random.random() > 0.5 else c for c in corrupted_hint)
    return render_template('forgot-password.html', hint=corrupted_with_noise)

@app.route('/api/stream_key')
def stream_key():
    def generate():
        characters = string.ascii_letters + string.digits + string.punctuation
        key_index = 0
        count = 0
        while True:
            if count % 3 == 0 and key_index < len(key):
                char = key[key_index]
                key_index += 1
            else:
                char = random.choice(characters)
            count += 1
            yield f"data: {char}\n\n"
            time.sleep(0.05)
    return Response(generate(), mimetype='text/event-stream')

@app.route('/api/stream_flag')
def stream_flag():
    def generate():
        characters = string.ascii_letters + string.digits + string.punctuation
        flag_index = 0
        count = 0
        while True:
            if count % 3 == 0 and flag_index < len(flag):
                char = flag[flag_index]
                flag_index += 1
            else:
                char = random.choice(characters)
            count += 1
            yield f"data: {char}\n\n"
            time.sleep(0.05)
    return Response(generate(), mimetype='text/event-stream')


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=80)
