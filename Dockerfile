FROM amberframework/amber:latest

WORKDIR /spec

COPY . /spec

RUN shards

CMD amber db migrate seed && bin/ameba && crystal tool format --check && crystal spec
