#!/usr/bin/env bash
set -e

AWS_ACCESS_KEY_ID=$(cat /tmp/AWS_ACCESS_KEY_ID)
AWS_SECRET_ACCESS_KEY=$(cat /tmp/AWS_SECRET_ACCESS_KEY)
S3_BUCKET_NAME=$(cat /tmp/S3_BUCKET_NAME)
sync_image=$(cat /tmp/sync_container_image)
znc_image=$(cat /tmp/znc_container_image)

# setup znc data sync sidecar
mkdir -p /opt/znc/data
cat <<EOF> /etc/systemd/system/s3_sync.service
[Unit]
Description=AWS S3 sync
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop -t 10 %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull $sync_image
ExecStart=/usr/bin/docker run --rm --name %n \
  -v /opt/znc/data:/mnt/data \
  -v /opt/znc:/opt/data \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e S3_REMOTE_PATH=$S3_BUCKET_NAME \
  $sync_image
ExecStop=docker stop %n

[Install]
WantedBy=default.target
EOF
systemctl start s3_sync
systemctl enable s3_sync

while [ ! -e /opt/znc/last_sync ]; do
  echo "waiting for initial sync to complete"
  sleep 5
done

# setup znc bouncer
cat <<EOF> /etc/systemd/system/znc.service
[Unit]
Description=ZNC
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop -t 10 %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull $znc_image
ExecStart=/usr/bin/docker run --rm --name %n \
  -v /opt/znc/data:/opt/znc/data \
  -p 0.0.0.0:6697:6697 \
  $znc_image
ExecStop=docker stop %n

[Install]
WantedBy=default.target
EOF
systemctl start znc
systemctl enable znc

cat <<EOF> /etc/systemd/system/znc.service
[Unit]
Description=ZNC
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop -t 10 %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull $znc_image
ExecStart=/usr/bin/docker run --rm --name %n \
  -v /opt/znc/data:/opt/znc/data \
  -p 0.0.0.0:6697:6697 \
  $znc_image
ExecStop=docker stop %n

[Install]
WantedBy=default.target
EOF
systemctl start znc
systemctl enable znc

# setup docker logrotation
cat <<EOF> /etc/logrotate.d/docker
/var/lib/docker/containers/*/*-json.log {
  hourly
  rotate 48
  compress
  dateext
  copytruncate
}
EOF
