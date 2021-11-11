FROM alpine:3 

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh cmd:pip3"]

RUN ["/bin/sh", "-c", "pip3 install checkov"]

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]
