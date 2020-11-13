# frozen_string_literal: true

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
end

require 'naughty_or_nice'

class TestHelper
  include NaughtyOrNice
end
