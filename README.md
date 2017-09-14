# Stringer

[![Build Status](https://api.travis-ci.org/swanson/stringer.svg?style=flat)](https://travis-ci.org/swanson/stringer)
[![Code Climate](https://codeclimate.com/github/swanson/stringer.svg?style=flat)](https://codeclimate.com/github/swanson/stringer)
[![Coverage Status](https://coveralls.io/repos/swanson/stringer/badge.svg?style=flat)](https://coveralls.io/r/swanson/stringer)
[![Dependency Status](https://gemnasium.com/swanson/stringer.svg)](https://gemnasium.com/swanson/stringer)

### A self-hosted, anti-social RSS reader.

Stringer has no external dependencies, no social recommendations/sharing, and no fancy machine learning algorithms.

But it does have keyboard shortcuts and was made with love!

![](screenshots/instructions.png)
![](screenshots/stories.png)
![](screenshots/feed.png)

## Installation

Stringer is a Ruby (2.3.0+) app based on Sinatra, ActiveRecord, PostgreSQL, Backbone.js and DelayedJob.

[![Deploy to Heroku](https://cdn.herokuapp.com/deploy/button.svg)](https://heroku.com/deploy)

Stringer will run just fine on the Heroku free plan.

Instructions are provided for deploying to [Heroku manually](/docs/Heroku.md), to any Ruby 
compatible [Linux-based VPS](/docs/VPS.md), and to [OpenShift](/docs/OpenShift.md).

## Niceties

### Keyboard Shortcuts

You can access the keyboard shortcuts when using the app by hitting `?`.

![](screenshots/keyboard_shortcuts.png)

### Using you own domain with Heroku

You can run Stringer at `http://reader.yourdomain.com` using a CNAME.

If you are on Heroku:

```
heroku domains:add reader.yourdomain.com
```

Go to your registrar and add a CNAME:
```
Record: CNAME
Name: reader
Target: your-heroku-instance.herokuapp.com
```

Wait a few minutes for changes to propagate.

### Fever API

Stringer implements a clone of [Fever's API](http://www.feedafever.com/api) so it can be used with any mobile client that supports Fever.

![image](https://f.cloud.github.com/assets/56947/546236/68456536-c288-11e2-834b-9043dc75a087.png)

Use the following settings:

```
Server: {path-to-stringer}/fever (e.g. http://reader.example.com/fever)

Email: stringer (case-sensitive)
Password: {your-stringer-password}
```

If you have previously setup Stringer, you will need to migrate your database and run `rake change_password` for the API key to be setup properly.

### Translations

Stringer has been translated to [several other languages](config/locales). Your language can be set with the `LOCALE` environment variable.

To set your locale on Heroku, run `heroku config:set LOCALE=en`.

If you would like to translate Stringer to your preferred language, please use [LocaleApp](http://www.localeapp.com/projects/4637).

### Clean up old read stories on Heroku

If you are on the Heroku free plan, there is a 10k row limit so you will
eventually run out of space.

You can clean up old stories by running: `rake cleanup_old_stories`

By default, this removes read stories that are more than 30 days old (that
are not starred). You can either run this manually or add it as a scheduled
task.

### Running "stringer" in "Docker" container

* Build "Stringer"'s "Docker" image

  ~~~
  docker build --tag swanson/stringer .
  ~~~

* Pull the "Docker" image

  ~~~
  docker pull swanson/stringer
  ~~~

* Push the "Docker" image to an isolated host

  ~~~
  # Pull image first to your local host
  docker pull swanson/stringer

  # Export image to local filesystem
  docker save -o /tmp/stringer.tar.gz swanson/stringer

  # Transfer image to host
  scp /tmp/stringer.tar.gz <host>:/tmp/

  # Export image to local filesystem
  ssh <host> docker load -i /tmp/stringer.tar.gz
  ~~~

* Run a container with "Stringer"

  To start "Stringer" with its defaults, use the following command.

  ~~~
  docker run --rm --name stringer-1 -p 5000:5000 swanson/stringer
  ~~~

  To configure the database for the container, use the `DATABASE_URL`-environment
  variable. For more information, please read the docs for
  ["ActiveRecord"](http://guides.rubyonrails.org/configuring.html#configuring-a-database).
  
  ~~~bash
  # PostgreSQL
  docker run --rm --name stringer-1 -p 5000:5000 -e DATABASE_URL="postgresql://localhost/blog_development?pool=5" swanson/stringer
  
  # Sqlite3
  docker run --rm --name stringer-1 -p 5000:5000 -e DATABASE_URL="sqlite3:///db/stringer.db" swanson/stringer
  ~~~
  
  To define the secret used to generate the session token, define `SECRET_TOKEN`.
  
  ~~~bash
  docker run --rm --name stringer-1 -p 5000:5000 -e SECRET_TOKEN="$(openssl rand -hex 32)" swanson/stringer
  ~~~
  
  To fetch stories, a cron daemon is used. You can configure the download of stories in minutes via `FETCH_STORIES_EVERY_MINUTES`.
  
  ~~~bash
  docker run --rm --name stringer-1 -p 5000:5000 -e FETCH_STORIES_EVERY_MINUTES=15 swanson/stringer
  ~~~
  
  To configure the amount of days when stringer starts to remove old stories, use `CLEANUP_STORIES_AFTER_DAYS`.
  
  ~~~bash
  docker run --rm --name stringer-1 -p 5000:5000 -e CLEANUP_STORIES_AFTER_DAYS=30 swanson/stringer
  ~~~
  
  By default "ActiveRecord" is verbose with logging. To "silence" it, run the
  container with `LOG_LEVEL=info`.
  
  ~~~bash
  docker run --rm --name stringer-1 -p 5000:5000 -e LOG_LEVEL=info swanson/stringer
  ~~~

* Run rake tasks in your container

  ~~~bash
  # docker run --rm --name stringer-1 -p 5000:5000 -e swanson/stringer bundle exec rake <task>
  docker run --rm --name stringer-1 -p 5000:5000 -e swanson/stringer bundle exec rake db:migrate
  ~~~

## Development

Run the Ruby tests with `rspec`.

Run the Javascript tests with `rake test_js` and then open a browser to `http://localhost:4567/test`.

### Getting Started

To get started using Stringer for development you first need to install `foreman`.

    gem install foreman

Then run the following commands.

```sh
bundle install
rake db:migrate
foreman start
```

The application will be running on port `5000`.

You can launch an interactive console (a la `rails c`) using `racksh`.

## Acknowledgements

Most of the heavy-lifting is done by [`feedjira`](https://github.com/feedjira/feedjira) and [`feedbag`](https://github.com/dwillis/feedbag).

General sexiness courtesy of [`Twitter Bootstrap`](http://twitter.github.io/bootstrap/) and [`Flat UI`](http://designmodo.github.io/Flat-UI/).

ReenieBeanie Font Copyright &copy; 2010 Typeco (james@typeco.com). Licensed under [SIL Open Font License, 1.1](http://scripts.sil.org/OFL).

Lato Font Copyright &copy; 2010-2011 by tyPoland Lukasz Dziedzic (team@latofonts.com). Licensed under [SIL Open Font License, 1.1](http://scripts.sil.org/OFL).

## Contact

If you have a question, feature idea, or are running into problems, our preferred method of contact is to open an issue on GitHub. This allows multiple people to weigh in and we can keep everything in one place. Thanks!

## Maintainers

Matt Swanson, [mdswanson.com](http://mdswanson.com), [@_swanson](http://twitter.com/_swanson)

Victor Koronen, [victor.koronen.se](http://victor.koronen.se/), [@victorkoronen](https://twitter.com/victorkoronen)
