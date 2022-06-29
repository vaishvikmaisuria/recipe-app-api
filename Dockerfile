FROM python:3.9-alpine3.13
LABEL maintainer="vaishvikmaisuria.com"

# python output is not buffered therefore logs are instant 
ENV PYTHONUNBUFFERED 1


COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# COPY ./scripts /scripts
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# one image layer -> single run command (more effcient) 
# 1. New virtual env to store dependencies for edge cases -> no downsides
# 2. full path for pip and upgrade pip 
# 3. install the client package to connect to postgress in the image
# 4. sets a virtual dependency package, it groups the packages we install into temp-build-deps 
# 5. install requirements in virtual env
# 6. remove tmp -> no extra dependencies after creation, docker images are lighweight 
# 7. adduser -> new user {best practice not use root user} 
# 8. disable password no password when using container 
# 9. our username is django-user 
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
         then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user 

# RUN python -m venv /py && \
#     /py/bin/pip install --upgrade pip && \
#     apk add --update --no-cache postgresql-client jpeg-dev && \
#     apk add --update --no-cache --virtual .tmp-build-deps \
#         build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     if [ $DEV = "true" ]; \
#         then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
#     fi && \
#     rm -rf /tmp && \
#     apk del .tmp-build-deps && \
#     adduser \
#         --disabled-password \
#         --no-create-home \
#         django-user && \
#     mkdir -p /vol/web/media && \
#     mkdir -p /vol/web/static && \
#     chown -R django-user:django-user /vol && \
#     chmod -R 755 /vol && \
#     chmod -R +x /scripts

# defines the directory were executables can be run from with env set up 
ENV PATH="/py/bin:$PATH"
# ENV PATH="/scripts:/py/bin:$PATH"

# the user we should be set too 
USER django-user
