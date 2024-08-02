FROM python:3.8-slim

# Set up the working directory for the Flask app
WORKDIR /app

# Copy the Flask app code into the container
COPY . /app

# Copy the setup script
COPY setup_disk_image.sh /usr/local/bin/setup_disk_image.sh
RUN chmod +x /usr/local/bin/setup_disk_image.sh

# Install Flask
RUN pip install flask

# Install necessary packages for SSH server, building sshttp, and disk mounting
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    gcc \
    g++ \
    make \
    libcap-ng0 \
    libcap-ng-dev \
    libcap-dev \
    e2fsprogs \
    conntrack \
    qemu-utils libguestfs-tools \
    && rm -rf /var/lib/apt/lists/*

# Build and install sshttp from source
RUN git clone https://github.com/stealth/sshttp.git && \
    cd sshttp/src && \
    make && \
    cp sshttpd /usr/local/bin/sshttpd && \
    cd ../.. && \
    rm -rf sshttp

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
RUN echo 'spartan:cortana' | chpasswd

# Create a flag file
RUN echo "flag{bf9a8f4e145af53efb74c079327d90a5}" > /home/spartan/.flag.txt

#Compile python into bytecode
RUN python -m compileall -b /app && \
    ls -la /app

#Delete files containg flags and instructions
RUN rm /app/README.md
RUN rm /app/app.py

# Expose ports for SSH and Flask
EXPOSE 22
EXPOSE 80


# Command to run both SSHD, sshttp, and Flask
CMD service ssh start && /usr/local/bin/setup_disk_image.sh && sshttpd -S 22 -H 80 -L 0.0.0.0:8080 && python -B /app/app.pyc
