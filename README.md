# Resque::Aliasing

Resque plugin that allows you to alias jobs to other jobs. Useful when you are renaming jobs or consolidating multiple jobs into one.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-aliasing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-aliasing

## Usage

If you ever want to rename a job, but are worried about versions of the old job still left in your resque queues, just alias it!
The below example illustrates basic usage after we have renamed a job from Workers::Processing::ProcessCustomer to
Workers::DiscombobulateCustomer.

    class Workers::DiscombobulateCustomer
        extend Resque::Plugins::Aliasing
        alias_job 'Workers::Processing::ProcessCustomer'

        def self.perform(customer_id)
            # discombobulating customer!
        end

        @queue = :customers
    end

Any Workers::Processing::ProcessCustomer jobs remaining in the queue will just get enqueued as Workers::DiscombobulateCustomer jobs when they are eventually 'performed'.
Additionally, any attempt to enqueue a Workers::Processing::ProcessCustomer job will instead enqueue a Workers::DiscombobulateCustomer job.










## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/resque-aliasing.

