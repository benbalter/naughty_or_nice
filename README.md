# Naughty or Nice

Naughty or Nice simplifies the process of extracting domain information from a domain-like string (an email, a URL, etc.) and checking whether it meets criteria you specify.

## Usage

Naughty or Nice doesn't do too much on its own. Out of the box, it can extract a domain from a domain-like string, and can verify that it is, in fact, a valid domain. It does this by leveraging the power of [Addressable](https://github.com/sporkmonger/addressable), the [Public Suffix List](http://publicsuffix.org/), and the associated [Ruby Gem](https://github.com/weppos/publicsuffix-ruby).

The true power of Naughty or Nice comes when you extended it into a child class.

## Extending Naughty or Nice

Let's say you have a list of three domains, `foo.com`, `bar.com`, and `foobar.com`. You'd spec out a class like so:

```ruby
class Checker < NaughtyOrNice
  DOMAINS = %w[foo.com bar.com foobar.com]

  def valid?
    DOMAINS.include? domain
  end
end
```

That's it! Just overwrite the `valid?` method and Naughty or Nice takes care of the rest.

## Using the extended class

There are a handful of magic methods that your child class automatically gets. You can throw any domain-like string at your new `Checker` class, and figure out if it's on the list. Here's a few examples:

```ruby
Checker.valid? "foo.com" #=> true
Checker.valid? "foo.org" #=> false
```

Notice we're using the class method `valid?` That automatically calls `Checker.new(string).valid?` for you. Cool, huh?

But you don't just need to give Checker crisp, clean domains. Let's get a bit trickier:

```ruby
Checker.valid? "http://foo.bar.com" #=> true
Checker.valid? "foo@bar.com" #=> true
Checker.valid? "foobar" => false
```

## Extracting domain information

You can also you NaughtyOrNice to extract domain information for use elsewhere. Continuing our above example:

```ruby
address = Checker.new "baz@foo.bar.com"
address.valid?           #=> true
address.domain           #=> "foo.bar.com"
address.domain_parts.tld #=> "com"
address.domain_parts.sld #=> "bar"
```

## See it in action

Take a look at [Gman](https://github.com/benbalter/gman) to see Naughty or Nice in action. Gman uses a crowd-sourced list of government domains to check if a given email address is a government email.
