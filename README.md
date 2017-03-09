# Wilderpeople

This tool was specifically design to assist in the identification of people
based on sets of matching data. However, it could also be used to retrieve
other types of data from an array.

The tool assumes you have an array of hashes, where each hash describes an
unique item or person. It then allows you to pass in a "matching dataset" and
in return it will return the hash that best matches that data, **if there
is only one best match.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wilderpeople'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wilderpeople

## Usage

Given the following dataset:

```ruby
data = [
  {surname: 'Bloggs', forename: 'Fred', gender: 'Male'},
  {surname: 'Bloggs', forename: 'Winifred', gender: 'Female'},
  {surname: 'Bloggs', forename: 'Jane', gender: 'Female'}
]
```

We have someone called Fred Bloggs, and we wish to find the hash that matches
them.

To do that we first need to identify the criteria on which to base the match.
As we just have a forename and surname, let's start with:

```ruby
config = {
  must: {
    surname: :exact,
    forename: :exact
  }
}
```

That is, to get a match the hash in the dataset must exactly match both the
surname and the forename.

With that information, we can now perform a search:

```ruby
search = Wilderpeople::Search.new(data: data, config: config)
person = search.find surname: 'Bloggs', forename: 'Fred'
person == {surname: 'Bloggs', forename: 'Fred', gender: 'Male'}
```

Success .... however, it turns out that the Winifred Bloggs we're after is
Frederick Blogg's sister, who also goes by the name 'Fred'.

So we could try changing the criteria in the config to look for a female Bloggs:

```ruby
config = {
  must: {
    surname: :exact,
    gender: :exact
  }
}
search = Wilderpeople::Search.new(data: data, config: config)
person = search.find surname: 'Bloggs', gender: 'Female'
person == nil
```

Unfortunately both Winifred Bloggs, and Jane Bloggs match that criteria, so the
search is unable to find an unique match, so returns `nil`.

So how do we identify the correct hash. The solution is to use fuzzy logic.

```ruby
config = {
  must: {
    surname: :exact,
    forename: :hypocorism,
    gender: :exact
  }
}
search = Wilderpeople::Search.new(data: data, config: config)
person = search.find surname: 'Bloggs', forename: 'Fred',  gender: 'Female'
person == {surname: 'Bloggs', forename: 'Winifred', gender: 'Female'}
```

### Criteria configuration

The `config` is a hash of one or two parts. The parts being:

* **must** The rules that must be matched
* **can** The rules that may be matched

Each part is itself a hash where the keys match the data keys, and the values
are the matchers to be used to compare the data in those keys.

```ruby
config = { must: { surname: :exact } }
```

With this configuration, the `exact` matcher will be used to compare the
`surname` of each hash in the data.

### Matchers

The matchers are defined by the protected methods in the
[Wilderpeople::Matcher class](https://github.com/reggieb/wilderpeople/blob/master/lib/wilderpeople/matcher.rb).
Please read the comments in this class to find out how each matcher operates.

### Can matching

If possible the match will be attempted using only the `must` criteria, but
if more that one match is returned, the system can then use the `can` criteria
to try and find a unique match.

So in the example above, Winifred could have been found using:

```ruby
config = {
  must: {
    surname: :exact,
    gender: :exact
  },
  can: {
    forename: :hypocorism
  }
}
search = Wilderpeople::Search.new(data: data, config: config)
person = search.find surname: 'Bloggs', forename: 'Fred',  gender: 'Female'
person == {surname: 'Bloggs', forename: 'Winifred', gender: 'Female'}
```

With this configuration the `hypocorism` matcher would only be called if the
search was unable to find a unique record by `surname` and `gender`. That is,
if we then went on to get Frederick's hash using the same configuration:

```ruby
person = search.find surname: 'Bloggs', forename: 'Fred',  gender: 'Male'
```

A unique record would be identified without having to do the `hypocorism` match.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/reggieb/wilderpeople.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

