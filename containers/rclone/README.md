# rclone + crond docker

```
$ docker run \ 
  -v $HOME/.znc:/mnt/data \
  -e AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE \
  -e AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY \
  -e S3_REMOTE_PATH=example-znc-bucket \
  nicolai86/rclone-sync:v0.1
```
