# znc docker 

```
$ git clone https://github.com/znc/znc.git /tmp/znc
$ cp Dockerfile /tmp/znc
$ cd /tmp/znc 
$ git submodule update --init --recursive
$ docker build -t znc .
$ docker run -i -t -v $HOME/.znc:/opt/znc/data -p 6667:6667 znc:latest
```
