#!/usr/bin/env sh

# AWS_DEFAULT_REGION
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# S3_REMOTE_PATH

export LOCAL_PATH=/mnt/data

echo Running S3 Sync

if [ "$(ls -A $LOCAL_PATH)" == "" ]; then
  echo "overwriting local."
  rclone sync remote:$S3_REMOTE_PATH $LOCAL_PATH
else
  echo "overwriting remote."
  rclone sync $LOCAL_PATH remote:$S3_REMOTE_PATH
fi

echo $(date) > /opt/data/last_sync

echo S3 Sync is done
