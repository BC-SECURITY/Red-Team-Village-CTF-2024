FROM python:3.8-slim

# Set up the working directory for the Flask app
WORKDIR /app

# Copy the Flask app code into the container
COPY . /app

# Install Flask
RUN pip install flask

# Install necessary packages for SSH masquerading
RUN apt-get update && apt-get install -y \
    openssh-server \
    sshttp \
    && rm -rf /var/lib/apt/lists/*

# Create SSH directory
RUN mkdir /var/run/sshd

# Add a custom SSH banner
RUN echo "Welcome to UNSC Secure Server 1.0" > /etc/ssh/ssh_banner

# Configure SSHD
RUN echo "Banner /etc/ssh/ssh_banner" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Add a test user
RUN useradd -ms /bin/bash spartan
RUN echo 'spartan:cortana123' | chpasswd

# Set up sshttp to masquerade the SSH server
RUN sshttp --ssh=22 --http=80 --listen=0.0.0.0 --sslport=443 &

# Expose ports for SSH and Flask
EXPOSE 22
EXPOSE 80

# Command to run both SSHD and Flask
CMD service ssh start && python /app/app.py
