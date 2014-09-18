Gem::Specification.new do |gem|
  gem.name    = 'naughty_or_nice'
  gem.version = "0.0.2"

  gem.summary     = "Given a domain-like string, verifies inclusion in a list you provide."
  gem.description = "You've made the list. We'll help you check it twice."

  gem.authors  = ['Ben Balter']
  gem.email    = 'ben.balter@github.com'
  gem.homepage = 'http://github.com/benbalter/naughty_or_nice'
  gem.license  = "MIT"

  gem.files = Dir['Rakefile', '{bin,lib}/**/*', 'README*', 'LICENSE*']

end
