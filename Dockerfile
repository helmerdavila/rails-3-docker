FROM ruby:3.1.4-alpine
RUN \
    # update packages
    apk update && apk upgrade && \
    # gem 'oj', 'puma', 'byebug'
    apk --no-cache add make gcc libc-dev && \
    apk add --update --no-cache \
    build-base curl-dev git libxslt-dev libxml2-dev ruby-rdoc mysql-dev \
    yaml-dev zlib-dev nodejs yarn tzdata

WORKDIR /app

# Required gems
RUN gem install nokogiri -- --use-system-libraries
RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# clear after installation
RUN rm -rf /var/cache/apk/*

ENV PATH=./bin:$PATH

EXPOSE 3000
CMD ["rails", "console"]