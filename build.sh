#!/usr/bin/env bash

docker rm -f bcsec-rtv-24 2>/dev/null
docker build -t bcsec-rtv-24 .
docker run -d --restart unless-stopped -p 8080:8080 --name bcsec-rtv-24 bcsec-rtv-24
