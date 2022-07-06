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

    Authentication:
        Simple Token: Balance of Security and Simplicity (used in the app)
        JWT: Better for more users and more secure need third party library (Future plan)

    APIView vs Viewsets
        What is view
            handles a request made url
            Django uses functions
            Django rest framework (DRF) uses class
                reusable logic
                override behavior

        ApiView and Viewsets = DRF base classes

        APIView is used to create authentication endpoints and are focused around HTTP mathods
        APIview is useful for non Crud APIs, bespoke logic (e.g. auth, jobs, external apis)
        Viewsets focused around actions (retrieve, list, update, partial update, destroy)
        Viewsets for Crud operations on models and use routers tro generate URLS and maps to the Django model.

    Testing Api with Swagger
        Navigate to http://localhost:8000/api/docs/
        Use /api/user/create to create user
        Use /api/user/token to get token for user
        Go to Authorize and then to "tokenAuth  (apiKey)"
        type "Token {user_token}" in the value field and authenticate
        Use and test the endpoint with Swagger
