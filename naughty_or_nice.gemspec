Gem::Specification.new do |gem|
  gem.name    = 'naughty_or_nice'
  gem.version = "0.0.4"

  gem.summary     = "You've made the list. We'll help you check it twice. Given a domain-like string, verifies inclusion in a list you provide."
  gem.description = "Naughty or Nice simplifies the process of extracting domain information from a domain-like string (an email, a URL, etc.) and checking whether it meets criteria you specify."

  gem.authors  = ['Ben Balter']
  gem.email    = 'ben.balter@github.com'
  gem.homepage = 'http://github.com/benbalter/naughty_or_nice'
  gem.license  = "MIT"

  gem.files = Dir['Rakefile', '{bin,lib}/**/*', 'README*', 'LICENSE*']

  gem.add_dependency( "public_suffix", '>= 1.2')
  gem.add_dependency( "addressable", '~> 2.3' )

  gem.add_development_dependency('pry', '~> 0.9')
  gem.add_development_dependency('shoulda', '~> 3.5')
  gem.add_development_dependency('rake', '~> 10.3')

end
