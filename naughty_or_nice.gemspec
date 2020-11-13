# frozen_string_literal: true

require File.expand_path('lib/naughty_or_nice/version', __dir__)

Gem::Specification.new do |gem|
  gem.name    = 'naughty_or_nice'
  gem.version = NaughtyOrNice::VERSION

  # rubocop: disable Metrics/LineLength
  gem.summary = "You've made the list. We'll help you check it twice. Given a domain-like string, verifies inclusion in a list you provide."
  gem.description = 'Naughty or Nice simplifies the process of extracting domain information from a domain-like string (an email, a URL, etc.) and checking whether it meets criteria you specify.'
  # rubocop: enable Metrics/LineLength

  gem.authors  = ['Ben Balter']
  gem.email    = 'ben.balter@github.com'
  gem.homepage = 'http://github.com/benbalter/naughty_or_nice'
  gem.license  = 'MIT'

  gem.files = Dir['Rakefile', '{bin,lib}/**/*', 'README*', 'LICENSE*']

  gem.add_dependency('addressable', '~> 2.3')
  gem.add_dependency('public_suffix', '>= 3.0')

  gem.add_development_dependency('pry', '~> 0.9')
  gem.add_development_dependency('rspec', '~> 3.5')
  gem.add_development_dependency('rubocop', '~> 1.0')
  gem.add_development_dependency('rubocop-performance', '~> 1.5')
  gem.add_development_dependency('rubocop-rspec', '~> 2.0')
end
