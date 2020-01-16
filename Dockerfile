FROM python:3.7-alpine
MAINTAINER Junya Sewai

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

#install the "PostgreSQL client" that comes with alpine
#--update   -> registry before we add
#--no-cache -> don't store the registry index on our dockerfile
RUN apk add --update --no-cache postgresql-client

#--virtual ->set up an alias for the dependencies which can be easily removed later.
# alias is going to be called ".tmp-build-deps"
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev

RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user