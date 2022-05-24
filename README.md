# Rails Dockerize

Setting up Docker for your Ruby and Rails environment.

You can still setup Ruby, PostgreSQL, Redis and the works up on your local machine if you'd prefer developing that way. Doing it with Docker just means you don't have to have any of that installed.

## Setup

Get your `master.key` file and put it in the `config` folder.

    docker compose run --rm rails -- bin/setup

Run the application and access it on <http://localhost:3001>

    docker compose up -d

View the logs.

    docker compose logs -f

Add `debugger` on a line you would like to debug, then connect to a Procfile process tmux window. Disconnect from the window with `ctrl + b`, `d`.

    docker compose exec rails bash
    overmind c web
    overmind c worker

To run any of the Rails commands, you'll have to prepend `docker compose run --rm rails` to the command.

    docker compose run --rm rails bin/rails c

Or just connect to the container and then run any of the Rails commands.

    docker compose exec rails bash
    bin/rails c

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

To build or rebuild your Docker image after `Dockerfile` or `Gemfile` updates.

    docker volume ls
    docker volume rm rails_dockerize_gem_cache_rails
    docker compose build rails
