#!/bin/bash

# Update the package list
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Start Nginx
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Install Python and pip
# sudo apt install -y python3 python3-pip

# Install Gunicorn
pip3 install gunicorn

# Create a sample Flask application
# cat <<EOF > /path/to/your/app.py
# from flask import Flask

# app = Flask(__name__)

# @app.route('/')
# def hello():
#     return "Hello, World!"

# if __name__ == '__main__':
#     app.run(debug=True)
# EOF

# Install Flask
pip3 install django

# Create Gunicorn systemd service file
cat <<EOF | sudo tee /etc/systemd/system/gunicorn.service
[Unit]
Description=Gunicorn service for your Flask application
After=network.target

[Service]
User=your_user
Group=your_group
WorkingDirectory=/path/to/your
ExecStart=/usr/local/bin/gunicorn -w 2 -b 127.0.0.1:8000 app:app

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Gunicorn service
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

# Configure Nginx
cat <<EOF > /etc/nginx/sites-available/myapp
server {
    listen 80;
    server_name your_domain_or_ip;

    location / {
        proxy_pass http://127.0.0.1:8000;  # Gunicorn default address
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static {
        alias /path/to/your/static/folder;
    }

    location /media {
        alias /path/to/your/media/folder;
    }
}
EOF

# Enable the Nginx site configuration
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled

# Test the Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
