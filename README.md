# Reproducible Project Template

This template repository simplifies setting up a reproducible data science project using Jupyter notebook.

The procedure outlined in this repository assumes you have a project that runs in a Jupyter notebook environment. Following the procedure in this notebook will 

* (Docker Hub) Build a docker image from your `Dockerfile`
    * From [Jupyter docker images](https://hub.docker.com/u/jupyter) ([Github repository](https://github.com/jupyter/docker-stacks), [Selecting an image](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html))
    * Or another Jupyter-notebook compatible image
    * And make the built image available on [Docker Hub](https://hub.docker.com)
* (Local/VM) Mange development environment by  
    * Automating any installation process with docker
    * Securing your Jupyter notebook server with self-signed keys and hashed password
    * Starting/stopping the server with simple commands
* (Binder) Allow project repository visitors to tryout your work without installing any software by 
    * Providing compatibility with [Binder](https://mybinder.org)
    * Having Binder load your docker image from Docker Hub
* (Travis) Continuously test your project by
    * Building docker image
    * Running test scripts

## Repository structure

* `binder/Dockerfile` (Binder): [docker image for Binder](https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html)
* `docker-compose.yml` (Local/VM): start/stop Jupyter notebook server process
* `Dockerfile` (Local/VM): defines Jupyter notebook environment
* `hooks/post_push` (Docker Hub): tags built images with Github commit hash substring
* `Makefile` (Travis): build docker image and run unit tests
* `setup.sh` (Local/VM): prepares local directory to run a server instance
* `tests/conftest.py` (Travis): _doesn't work yet_
* `tests/requirements.txt` (Travis): _doesn't work yet_
* `tests/test_job.py` (Travis): _doesn't work yet_

## Initial Setup

* Update `Makefile`
   * `IMAGE` variable names locally built docker image
   * `TAG` variable is the default docker image tag
   
* Update Docker Hub: _to do_

* Update Travis CI: _to do_

## Local/VM Development Server

### Install Docker and build image

```bash
# install necessary packages on debian or ubuntu
sudo apt-get update && \
   sudo apt-get install -y wget git docker.io docker-compose && \
   sudo usermod -aG docker $USER

# re-login to to apply docker group setting

git clone https://github.com/dddlab/project-template.git
cd project-template/
chmod u+x setup.sh
./setup.sh 
make build
```

### Start/Stop Jupyter notebook server

```bash
make start
make stop
```

## Running on Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/dddlab/project-template/master)

* File `binder/Dockerfile` defines a docker image for Binder sessions
* Update base image to point to a [stable docker image](https://hub.docker.com/repository/docker/dddlab/project-template/tags?page=1)
