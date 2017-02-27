# ICFJ Impact Tracker

## Requirements
  * Ruby 2.3.3
  * Rails 5.0.0.1
  * PostgreSQL
  * Redis

## Getting Started
1. Clone the project ` git clone https://github.com/pykih/icfj-impact-tracker.git `
2. Install the required dependencies ` bundle install `
3. Setting environment variables using `.env` file
   * `AIRTABLE_API_KEY` the API key for the Airtable account.
   * `AIRTABLE_APP_KEY` the application key for the Airtable account.
   * `IMPACT_MONITOR_KEY` the API key for Impact monitor account.
   * `CHANNEL_ID` the id of the channel to be used in Impact monitor.
   * `CHANNEL_UNIQUEID` the unique id of a channel to be used in Impact monitor.
   * `EMAIL_USERNAME`, `EMAIL_PASSWORD` and `EMAIL_FROM_ADDRESS` email configuration parameters.
4. Run `bundle exec rake db:setup` to setup the database.
5. Optionally run tasks to populate the application specific data: (requires running instance of sidekiq) (see [Airtable data model][1] before running the tasks )
  * `bundle exec rake jobs:hourly`
  * `bundle exec rake jobs:refresh_mat_view`
6. Start application
  * On production env, use the Procfile to start all application instances
  * On dev, run `foreman start`

The application is tightly bound to the third party applications [Impact monitor][2] and [Airtable][3] a detailed documentation on the configuration can be found at [Airtable data model][1]

[1]: https://github.com/pykih/icfj-impact-tracker/wiki
[2]: http://impactmonitor.net/app/login.php
[3]: https://airtable.com/
