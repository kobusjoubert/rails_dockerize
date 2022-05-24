# Dockerfile best practices. [https://lipanski.com/posts/dockerfile-ruby-best-practices]
FROM ruby:3.1.2-alpine AS base

# Install system dependencies required both at runtime and build time.
#
# gcompat
#
#   LoadError: Error loading shared library ld-linux-aarch64.so.1: No such file or directory.
#   [https://nokogiri.org/tutorials/installing_nokogiri.html#linux-musl-error-loading-shared-library]
#   [https://wiki.alpinelinux.org/wiki/Running_glibc_programs]
RUN apk update && apk add --no-cache --update postgresql-dev tzdata curl screen htop vim git bash yarn imagemagick gcompat

# Match Gemfile.lock 'BUNDLED WITH' version.
RUN gem install bundler:2.3.13

# This stage will be responsible for installing gems.
FROM base AS dependencies

# Install system dependencies required to build some Ruby gems (pg).
RUN apk add --update build-base

COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'development test' && bundle install --retry=3

# Runtime.
FROM base

# Create a non-root user to run the app and own app-specific files.
RUN adduser --disabled-password app

# Set the user for RUN, CMD or ENTRYPOINT calls from now on.
# Note that this doesn't apply to COPY or ADD, which use a --chown argument instead.
# Switch to this user.
USER app

# Set the base directory that will be used from now on.
# We'll install the app in this directory.
WORKDIR /home/app

# Copy over gems from the dependencies stage.
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

# Finally, copy over the code.
COPY --chown=app . ./

# Script to be executed every time the container starts.
RUN chmod +x ./docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]

# Document which ports are intended to be published. This does not actually publish the port.
ENV PORT 3000
EXPOSE 3000

# Configure the main process to run when running the image.
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
