# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_shipstation'
  s.version     = '1.0.0'
  s.summary     = 'Spree 3/ShipStation Integration'
  s.description = 'Integrates ShipStation API with Spree. Supports exporting shipments and importing tracking numbers'
  s.required_ruby_version = '>= 2.4.0'

  s.author    = 'Matthew Kennedy'
  s.email     = 'not@valable.com'
  s.homepage  = 'https://github.com/MatthewKennedy/spree_shipstation'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', ' >= 3.4.4', '< 4'
 
  s.add_development_dependency 'capybara', '~> 2.7'
  s.add_development_dependency 'coffee-rails', '~> 4.2'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot', '~> 4.7'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'rspec-xsd'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'spree_auth_devise'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'

end
