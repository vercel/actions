.PHONY: ruby-bootstrap
ruby-bootstrap:
	rbenv install -s
	gem install bundler

.PHONY: ruby-bundle
ruby-bundle:
	bundle install

.PHONY: ruby-lint
ruby-lint: ruby-bundle
	rake lint

.PHONY: ruby-test
ruby-test: ruby-bundle
	rake test

