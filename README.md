# GH Actions Docker Setup

This repository is meant to allow GitHub actions to run in a Docker container with minimal setup.

I must give a lot of credit to [this](https://baccini-al.medium.com/how-to-containerize-a-github-actions-self-hosted-runner-5994cc08b9fb) article for the main code and inspiration for this script.

## Example Docker Setup

```YAML
services:
    runner:
        image: beanbeanjuice/gh-actions-runner:latest
        restart: unless-stopped
        environment:
            REPO: <owner>/<repo>
            TOKEN: <github-pat>
        deploy:
            mode: replicated
            replicas: 4
            resources:
                limits:
                    cpus: '0.35'
                    memory: 300M
                reservations:
                    cpus: '0.25'
                    memory: 128M
```
