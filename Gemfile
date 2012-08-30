source 'http://rubygems.org'
gemspec

group(:test) do
  gem 'sqlite3', :platform => [:ruby, :mswin, :mingw]
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby

  gem 'mysql2', :platform => [:ruby, :mswin, :mingw]
  gem 'activerecord-jdbcmysql-adapter', :platform => :jruby

  gem 'pg', :platform => [:ruby, :mswin, :mingw]
  gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby

  gem 'simplecov', :require => false
end


group :development do
  gem "rspec", ">= 2.4.0"
  gem "bundler", "~> 1.1.2"
  gem "jeweler", "> 1.6.4"
  gem 'i18n-spec'
  gem 'localeapp'
end
