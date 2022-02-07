FROM alpine:3.15

RUN ["/bin/sh", "-c", "apk add --update --no-cache gcc libffi-dev python3-dev musl-dev bash ca-certificates curl git jq openssh findutils cmd:pip3"]

RUN ["/bin/sh", "-c", "pip3 install wheel"]

RUN ["/bin/sh", "-c", "pip3 install checkov"]

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]