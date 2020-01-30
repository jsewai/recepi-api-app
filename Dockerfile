FROM python:3.7-alpine
MAINTAINER Junya Sewai

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

#install the "PostgreSQL client" that comes with alpine
#--update   -> registry before we add
#--no-cache -> don't store the registry index on our dockerfile
RUN apk add --update --no-cache postgresql-client jpeg-dev

#--virtual ->set up an alias for the dependencies which can be easily removed later.
# alias is going to be called ".tmp-build-deps"
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

#mkdir -p not to show errors
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
#-R means recursive
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
# after USER user, cannot modify any setting
USER user