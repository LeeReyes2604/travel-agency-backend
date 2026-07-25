# syntax=docker/dockerfile:1

############################
# Base Image
############################
FROM ruby:3.2.3-slim AS base

ENV APP_PATH=/app \
    BUNDLE_PATH=/usr/local/bundle

WORKDIR ${APP_PATH}

# Runtime packages only
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    default-mysql-client \
    libmariadb3 \
    libjemalloc2 \
    libvips \
 && rm -rf /var/lib/apt/lists/*

############################
# Build Stage
############################
FROM base AS build

# Packages needed only to compile gems
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    pkg-config \
    default-libmysqlclient-dev \
    libyaml-dev \
 && rm -rf /var/lib/apt/lists/*

# Install gems first (Docker layer caching)
COPY Gemfile Gemfile.lock ./

RUN bundle install

# Copy application source
COPY . .

############################
# Runtime Image
############################
FROM base

# Create non-root user
RUN groupadd --system rails && \
    useradd --system --gid rails --create-home rails

# Copy installed gems with correct ownership
COPY --from=build --chown=rails:rails /usr/local/bundle /usr/local/bundle

# Copy application with correct ownership
COPY --from=build --chown=rails:rails /app /app

USER rails

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]