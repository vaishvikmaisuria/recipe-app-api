# recipe-app-api
Recipe API project


create a Django app in docker compose 
 - docker-compose run --rm app sh -c "django-admin startproject app ."


Why Github Actions
    Common Uses 
        1. Deployment (not in this project)
        2. Code linting 
        3. Unit testing 
    Set up triggers 
        1. when code is pushed to github 
    Price 
        1. charged per min 
        2. 2000 mins free 
        3. various other plans 

Architecture 
    Database:
        PostgreSQL 
            1. Popular open source DB
            2. Integrates well with Django 
        Docker Compose
            1. Defined with project (re-usable)
            2. Persistent data using volumes 
            3. handles network configuration 
            4. environment variable configuration 

