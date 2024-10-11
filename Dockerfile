FROM python:3.8-slim

# Set up the working directory for the Flask app
WORKDIR /app

# Copy the Flask app code into the container
COPY /app /app

# Install Flask
RUN pip install flask

# Install necessary packages for SSH server, building sshttp, and disk mounting
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    openssh-server \
    sslh \
    qemu-utils libguestfs-tools \
    && rm -rf /var/lib/apt/lists/*


# Create SSH directory
RUN mkdir /var/run/sshd

# Add a custom SSH banner
RUN echo "Welcome to UNSC Secure Server 1.0" > /etc/ssh/ssh_banner

# Configure SSHD
RUN echo "Banner /etc/ssh/ssh_banner" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Add a test user
RUN useradd -ms /bin/bash spartan
RUN echo 'spartan:cortana' | chpasswd

# Create a flag file
RUN echo "flag{bf9a8f4e145af53efb74c079327d90a5}" > /home/spartan/.flag.txt

# Copy the setup script
COPY setup_disk_image.sh /usr/local/bin/setup_disk_image.sh
RUN chmod +x /usr/local/bin/setup_disk_image.sh
RUN /usr/local/bin/setup_disk_image.sh

#Compile python into bytecode
RUN python -m compileall -b /app && \
    ls -la /app

# Expose port 8080
EXPOSE 8080

# Command to run both SSHD, sshttp, and Flask
CMD service ssh start && sslh --listen=0.0.0.0:8080 --http=localhost:80 --ssh=localhost:22 && python -B /app/app.pyc
