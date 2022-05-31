# Rails Dockerize

Setting up Docker for your Ruby and Rails environment.

You can still setup Ruby, PostgreSQL, Redis and the works up on your local machine if you'd prefer developing that way. Doing it with Docker just means you don't have to have any of that installed.

## Setup

Get your `master.key` file and put it in the `config` folder.

    docker compose run --rm rails -- bin/setup

## Usage

Run the application and access it on <http://localhost:3001>

    docker compose up -d

View the logs.

    docker compose logs -f

Add `debugger` on a line you would like to debug, then attach to a container to investigate. Detach from the container with `ctrl + p`, `ctrl + q`.

    docker container ls
    docker attach rails_dockerize-rails-1

To run any of the Rails commands, you'll have to prepend `docker compose run --rm rails` to the command.

    docker compose run --rm rails bin/rails c

Or just connect to the container and then run any of the Rails commands.

    docker compose exec rails bash
    bin/rails c

To run tests.

    docker compose exec -e RAILS_ENV=test rails bash
    bin/rubocop
    bin/rspec

Stop the application.

    docker compose stop

## Upgrade

To upgrade Rails, in `Gemfile` change `gem 'rails', '~> 7.0.0'`.

    docker compose exec -u root rails bash
    git rm Gemfile.lock
    bundle install
    bin/rails app:update
    bin/rails db:migrate

## Build

### Development

To build or rebuild your Docker image after `Dockerfile` or `Gemfile` updates.

    docker volume ls
    docker volume rm rails_dockerize_gem_cache
    docker compose build

### Production

    docker build --build-arg RUBY_VERSION=3.1.2 --build-arg BUNDLER_VERSION=2.3.13 --file Dockerfile --tag rails_dockerize_production --target production .

## Files

These are the files of interest that need to be added or altered.

- [Dockerfile](Dockerfile)
- [docker-compose.yml](docker-compose.yml)
- [docker-entrypoint.sh](docker-entrypoint.sh)
- [.dockerignore](.dockerignore)
- [Gemfile](Gemfile)
- [Procfile.dev](Procfile.dev)
- [bin/setup](bin/setup)
- [bin/dev](bin/dev)
- [config/cable.yml](config/cable.yml)
- [config/database.yml](config/database.yml)
- [.env.template](.env.template)

## Known Issues

If you run into this error when running `docker compose up`, just run `docker compose up` again. I need to find a way around this. 🤔

    Error response from daemon: failed to mkdir /var/lib/docker/volumes/rails_dockerize_bundle/_data/actionmailer-7.0.3/lib/action_mailer: mkdir /var/lib/docker/volumes/rails_dockerize_bundle/_data/actionmailer-7.0.3/lib/action_mailer: file exists
