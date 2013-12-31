# Yapt

A command line Pivotal Tracker client. In early days.

## Installation

    $ gem install yapt

## Usage

Put these in a yaml .yapt file in your project or ~ directory:

* api_token
* project_id

yapt list "created_since=last friday" limit=5 keyword

Use a different template with v(iew)=

yapt list v=detail
yapt list view=simple

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
