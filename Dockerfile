# Dockerfile best practices. [https://lipanski.com/posts/dockerfile-ruby-best-practices]
ARG RUBY_VERSION=3.0
FROM ruby:$RUBY_VERSION-alpine AS base

# Install system dependencies required both at runtime and build time.
#
# gcompat
#
#   LoadError: Error loading shared library ld-linux-aarch64.so.1: No such file or directory.
#   [https://nokogiri.org/tutorials/installing_nokogiri.html#linux-musl-error-loading-shared-library]
#   [https://wiki.alpinelinux.org/wiki/Running_glibc_programs]
RUN apk update && apk add --no-cache --update postgresql-dev tzdata curl screen htop vim git bash yarn imagemagick vips gcompat

# Match Gemfile.lock 'BUNDLED WITH' version.
ARG BUNDLER_VERSION=2.3
RUN gem install bundler:$BUNDLER_VERSION

# This stage is responsible for installing jemalloc in favour of malloc.
# [https://github.com/docker-library/ruby/issues/182#issuecomment-939047364]
# [https://devcenter.heroku.com/changelog-items/1683]
FROM base AS jemalloc
RUN apk add --no-cache --update build-base
RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
  cd jemalloc-5.2.1 && \
  ./configure && \
  make && \
  make install

# This stage will be responsible for installing gems.
FROM base AS dependencies

# Install system dependencies required to build some Ruby gems (pg).
RUN apk add --update build-base

# This stage will be responsible for installing gems for development.
FROM dependencies AS development-dependencies

# Copying these files as an independent step, followed by bundle install, means that the project gems do not need to be rebuilt every time you make changes to
# your application code. This will work in conjunction with the gem_cache volumes that we will include in our docker-compose.yml file, which will mount gems to
# your application container in cases where the service is recreated but project gems remain the same.
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install --jobs=2 --retry=3

# This stage will be responsible for installing gems for production.
FROM dependencies AS production-dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && bundle install --jobs=2 --retry=3

# Runtime.
FROM base AS runtime

# Create a non-root user to run the app and own app-specific files.
RUN adduser --disabled-password app

# Set the user for RUN, CMD or ENTRYPOINT calls from now on.
# Note that this doesn't apply to COPY or ADD, which use a --chown argument instead.
# Switch to this user.
USER app

# Set the base directory that will be used from now on.
# We'll install the app in this directory.
WORKDIR /home/app

# Copy over jemalloc from the jemalloc stage.
COPY --from=jemalloc /usr/local/lib/libjemalloc.so.2 /usr/local/lib/

# Inject jemalloc to transparently replace the system malloc with jemalloc without Ruby being aware of this. Any invocation inside your container (be it the
# entrypoint or a command) will be enhanced by jemalloc.
ENV LD_PRELOAD=libjemalloc.so.2

# If there is any output from this command, jemalloc installed correctly.
# RUN MALLOC_CONF=stats_print:true ruby -e "exit"

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

# Development.
FROM runtime AS development

# Copy over gems from the development-dependencies stage.
COPY --from=development-dependencies /usr/local/bundle/ /usr/local/bundle/

# Production.
FROM runtime AS production

# Copy over gems from the production-dependencies stage.
COPY --from=production-dependencies /usr/local/bundle/ /usr/local/bundle/
