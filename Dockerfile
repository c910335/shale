FROM amberframework/amber:v0.9.0

WORKDIR /app

COPY . /app

RUN shards build ameba

CMD amber db migrate seed && bin/ameba && crystal tool format --check && crystal spec
