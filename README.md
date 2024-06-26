# Red-Team-Village-CTF-2024

1. Access the login portal at http://localhost
2. There is a hint for a commented out endpoint /forgot_password on the main page
3. The endpoint /forgot_password gives the hint for the username and password
4. Users can then login to the communication system
5. All communciation systems messages are encrypted and require a key
6. The key can be found as a stream on the login page with every 3rd letter being the key
7. The flag can also be found on the login page with every 3rd letter being the flag