FROM ruby:2.3.3-alpine

RUN apk update
RUN apk add --no-cache make gcc postgresql-dev libc-dev linux-headers libxml2-dev libxslt-dev sqlite-dev g++

RUN gem install foreman
RUN gem install bundler
RUN gem install clockwork

WORKDIR /app/

ADD Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without development test

#######

FROM ruby:2.3.3-alpine

MAINTAINER mdswanson@sep.com

ENV PORT 5000
ENV SECRET_TOKEN ""
ENV DATABASE_URL "sqlite3:///db/stringer.db"
ENV FETCH_STORIES_EVERY_MINUTES 15
ENV CLEANUP_STORIES_AFTER_DAYS 30
ENV LOG_LEVEL=info

RUN apk add --no-cache libxml2 libxslt postgresql-libs sqlite-libs nodejs

COPY --from=0  /usr/local/bundle/ /usr/local/bundle/

WORKDIR /app/

ADD . .

RUN rm config/database.yml
RUN echo "cron: bundle exec clockwork config/clockwork.rb" >> Procfile
RUN sed -i "s/^console/# console/" Procfile

RUN echo -e "#!/bin/sh\n/usr/local/bundle/bin/rake db:migrate && echo \"Starting stringer! Just a moment, please ...\" && sleep 2 && /usr/local/bundle/bin/foreman start" > /usr/local/bin/stringer
RUN chmod +x /usr/local/bin/stringer

EXPOSE 5000

CMD ["/usr/local/bin/stringer"]
