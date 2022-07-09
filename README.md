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

Deployment
    We wanted a simple and low cost deployment solution

    1. Deployment on AWS EC2 instance
       1. setup a proxy
       2. handle static / media files
       3. configuration
          1. Persistent Data (data)
          2. WSGI (Web server gateway interface) {app}
          3. Reverse Proxy {request from public}

       4. nginx -> webserver
          1. open source, fast, secure, production grade
       5. uWSGI -> WSGI
          1. open sourse, fast, lightweight, simple to use
          2. Alternative you could use (Gunicorn)


# Deployment


## Server Setup

### Creating an SSH Deploy Key

To create a new SSH key which can be used as the deploy key, run the command below:

```sh
ssh-keygen -t ed25519 -b 4096
```

Note: This will create a new `ed25519` key, which is the recommended key for GitHub.

To display the public key, run:

```sh
cat ~/.ssh/id_ed25519.pub
```


### Install and Configure Depdencies

Use the below commands to configure the EC2 virtual machine running Amazon Linux 2.

Install Git:

```sh
sudo yum install git -y
```

Install Docker, make it auto start and give `ec2-user` permissions to use it:

```sh
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker ec2-user
```

Note: After running the above, you need to logout by typing `exit` and re-connect to the server in order for the permissions to come into effect.

Install Docker Compose:

```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```


## Running Docker Service


### Cloning Code

Use Git to clone your project:

```sh
git clone <project ssh url>
```

Note: Ensure you create an `.env` file before starting the service.


### Running Service

To start the service, run:

```sh
docker-compose -f docker-compose-deploy.yml up -d
```

### Stopping Service

To stop the service, run:

```sh
docker-compose -f docker-compose-deploy.yml down
```

To stop service and **remove all data**, run:

```sh
docker-compose -f docker-compose-deploy.yml down --volumes
```


### Viewing Logs

To view container logs, run:

```sh
docker-compose -f docker-compose-deploy.yml logs
```

Add the `-f` to the end of the command to follow the log output as they come in.


### Updating App

If you push new versions, pull new changes to the server by running the following command:

```
git pull origin
```

Then, re-build the `app` image so it includes the latest code by running:

```sh
docker-compose -f docker-compose-deploy.yml build app
```

To apply the update, run:

```sh
docker-compose -f docker-compose-deploy.yml up --no-deps -d app
```

The `--no-deps -d` ensures that the dependant services (such as `proxy`) do not restart.