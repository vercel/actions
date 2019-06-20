# GitHub Action for Docker Tag

The GitHub Action for Docker tagging uses the current environment to tag built images with a variety of GitHub identifiers:

* SHA
* Ref
* Version (from Dockerfile)
* `latest` (if requested)

## Usage

The tag action requires at least two arguments: the image to be tagged, that must have been built in a prior step, and the desired image name (without tags). An example:

```
action "tag" {
  uses = "actions/docker/tag@master"
  args = "base github/base"
}
```

This will look at the following:

* `GITHUB_REF` environment variable, turning `heads/refs/master` -> `master`
* `GITHUB_SHA` taking the first seven characters
* `version` `LABEL` from the Dockerfile

It is possible to disable these tags by passing:

* `--no-latest` for no `:latest` tag
* `--no-sha` for no SHA tag
* `--no-ref` for no Ref-based tag

In addition, passing `--env` will write out all of these tags as environment variables. The location is `$HOME/.profile` by default, but can be overridden with `--env-file`

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE.md).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
