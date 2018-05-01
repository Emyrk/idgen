# https://hub.docker.com/_/golang
FROM golang:1.10-alpine

MAINTAINER Instrumentisto Team <developer@instrumentisto.com>

RUN apk add --update --no-cache \
        ca-certificates \
        # https://github.com/Masterminds/glide#supported-version-control-systems
        git mercurial subversion bzr \
        openssh \
 && update-ca-certificates \
    \
 # Install build dependencies
 && apk add --no-cache --virtual .build-deps \
        curl make \
    \
 # Download and unpack Glide sources
 && curl -L -o /tmp/glide.tar.gz \
          https://github.com/Masterminds/glide/archive/v0.13.1.tar.gz \
 && tar -xzf /tmp/glide.tar.gz -C /tmp \
 && mkdir -p $GOPATH/src/github.com/Masterminds \
 && mv /tmp/glide-* $GOPATH/src/github.com/Masterminds/glide \
 && cd $GOPATH/src/github.com/Masterminds/glide \
    \
 # Build and install Glide executable
 && make install \
    \
 # Install Glide license
 && mkdir -p /usr/local/share/doc/glide \
 && cp LICENSE /usr/local/share/doc/glide/ \
    \
 # Cleanup unnecessary files
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
           $GOPATH/src/* \
           /tmp/*



# Server Identity
# Where serveridentity sources will live
WORKDIR $GOPATH/src/github.com/FactomProject
RUN git clone https://github.com/FactomProject/serveridentity.git

WORKDIR $GOPATH/src/github.com/FactomProject/serveridentity
# Checkout branch with host option
RUN git fetch
RUN git checkout withhost

RUN glide install
RUN go install

WORKDIR $GOPATH/src/github.com/FactomProject/serveridentity/signwithed25519

RUN go install

# factom-walletd
WORKDIR $GOPATH/src/github.com/FactomProject
RUN git clone https://github.com/FactomProject/factom-walletd.git
WORKDIR $GOPATH/src/github.com/FactomProject/factom-walletd
RUN glide install
RUN go install

# factom-cli
WORKDIR $GOPATH/src/github.com/FactomProject
RUN git clone https://github.com/FactomProject/factom-cli.git
WORKDIR $GOPATH/src/github.com/FactomProject/factom-cli
RUN glide install
RUN go install

WORKDIR $GOPATH/src/github.com/FactomProject/
ADD guide.sh $GOPATH/src/github.com/FactomProject/

ARG FACTOMDHOST


ENTRYPOINT ["sh"]
#ENTRYPOINT ["factom-walletd", "-s=courtest.factom.com"]
#ENTRYPOINT ["factom-walletd", "-s=136.243.66.19:8088"]
