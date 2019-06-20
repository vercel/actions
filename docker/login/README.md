# GitHub Action for Docker Login

The GitHub Action for [Docker](https://docker.com/) Login wraps the Docker CLI's `docker login`, allowing for Actions to log into Docker.

Because `$HOME` is persisted across Actions, the `docker login` command will save this information into `$HOME/.docker/config.json`, allowing other Actions to push, pull or otherwise modify images.

## Usage

There are two required Secrets to be set:

* `DOCKER_USERNAME` - this is the username used to log in to your Docker registry.
* `DOCKER_PASSWORD` - this is the password used to log in to your Docker registry.

An example of logging into Docker Hub would look like this:

```
action "Docker Login" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}
```

In addition, if you're logging into a registry that's not Docker Hub, you can add a secret at `DOCKER_REGISTRY_URL` to point to a different registry.

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE.md).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
