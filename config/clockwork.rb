require 'clockwork'

module Clockwork
  handler do |job, time|
    puts "Running #{job}, at #{time}"
  end

  every(ENV["FETCH_STORIES_EVERY_MINUTES"].to_i.minutes, 'fetch feeds') do
    `bundle exec rake fetch_feeds`
  end

  every(1.day, 'cleanup old stories') do
    `bundle exec cleanup_old_stories #{ENV["CLEANUP_STORIES_AFTER_DAYS"]}`
  end
end
