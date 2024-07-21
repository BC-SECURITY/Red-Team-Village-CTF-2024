# Red Team Village CTF 2024

## Install Instructions
1. Build the Docker Image:
`docker build --no-cache -t bcsec-rtv-24 .`

3. Run the Docker Container:
`docker run -d -p 8080:8080 -p 80:80 -p 22:22 --restart=always --privileged bcsec-rtv-24`

## Walkthrough
1. Open your web browser and go to http://localhost.
2. Inspect the HTML source of the main page to find the commented out /forgot_password endpoint.
3. The endpoint /forgot_password gives the hint for the username and password
4. Access the endpoint /forgot_password to get the hint for the username and password.
5. Use the credentials to login through the main portal.
6. Note that all messages are encrypted and require a key for decryption.
7. A hint on the messages page suggests that "all things come in 3s."
8. On the login page, look for a stream where every 3rd letter is part of the decryption key.
9. Similarly, on the login page, find another stream where every 3rd letter is part of the flag.
10. Use the key found in step 8 to decrypt the messages and obtain another flag.
11. Log in to the SSH server using the stolen credentials: `ssh -p 22 spartan@localhost`
12. List hidden files: `ls -a`
13. Get the contents of the hidden flag: `cat .flag.txt`
14. Mount the disk image: `mount /home/spartan/disk.img /mnt`
15. Get the hidden flag from the mounted disk: `cat /mnt/hidden_flag.txt`
