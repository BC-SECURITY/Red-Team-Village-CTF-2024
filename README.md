# Red Team Village CTF 2024

## Install Instructions

Run `build.sh` to build the docker image and run the container.

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
11. Log in to the SSH server using the stolen credentials: `ssh -p 8080 spartan@localhost`
12. List hidden files: `ls -a`
13. Get the contents of the hidden flag: `cat .flag.txt`
14. Mount the disk image: `mount /home/spartan/disk.img /mnt`
15. Get the hidden flag from the mounted disk: `cat /mnt/hidden_flag.txt`


## Name: UNSC Communication :: 001
### Category: UNSC Communication
### Description
```md

The UNSC has been working on a new communication system to help keep their data secure.

They have a weird stream of data on the main page, can you find the flag?

Challenge Courtesy of <a href="https://github.com/BC-SECURITY" target="_blank">BC-Security!</a>
```

### Value: 20
### Tags: web
### attempts: 0
### Flag
flag{c533655a69aebaecd2340d54fe599682}

### Solution:
```md

```

## Name: UNSC Communication :: 002
### Category: UNSC Communication
### Description
```md

There seems to be more than one stream of data on the main page.

See if you can retrieve that, it might come in handy!

Login to the system and decrypt the data to find the flag.

Challenge Courtesy of <a href="https://github.com/BC-SECURITY" target="_blank">BC-Security!</a>
```

### Value: 35
### Tags: web
### attempts: 0
### Flag
flag{babc9b8b4405d67cf28d58fe56ef96ccg}

### Solution:
```md

```

## Name: UNSC Communication :: 003
### Category: UNSC Communication
### Description
```md

The host is multiplexing HTTP and SSH on the same port.

Can you ssh into the system and find the flag?

Challenge Courtesy of <a href="https://github.com/BC-SECURITY" target="_blank">BC-Security!</a>
```

### Value: 15
### Tags: web
### attempts: 0
### Flag
flag{bf9a8f4e145af53efb74c079327d90a5}

### Solution:
```md

```

## Name: UNSC Communication :: 004
### Category: UNSC Communication
### Description
```md

Find the last flag in the system.

Challenge Courtesy of <a href="https://github.com/BC-SECURITY" target="_blank">BC-Security!</a>
```

### Value: 15
### Tags: web
### attempts: 0
### Flag
flag{5007e994724962398cb5634b8bbbdbf2}

### Solution:
```md

```

