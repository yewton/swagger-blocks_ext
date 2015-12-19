FROM ruby:2.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY . /swagger-blocks_ext

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY docker/Gemfile /usr/src/app/
COPY docker/Gemfile.lock /usr/src/app/
RUN ["bundle", "install", "--binstubs"]

COPY docker /usr/src/app

ENTRYPOINT ["bin/rake"]
