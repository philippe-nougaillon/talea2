web: bundle exec puma -C config/puma.rb
release: bundle exec rake db:schema:load
worker: bundle exec rake solid_queue:start