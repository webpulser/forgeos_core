Gem::Specification.new do |s|
  s.add_dependency 'rails', '>= 3.1.0.rc4'
  s.name = 'forgeos_core'
  s.version = '1.9.9'
  s.date = '2011-06-29'

  s.summary = 'Core of Forgeos plugins suite'
  s.description = 'Forgeos Core provide users, libraries and administration rights and roles based management'

  s.authors = ['Cyril LEPAGNOT', 'Jean Charles Lefrancois']
  s.email = 'dev@webpulser.com'
  s.homepage = 'http://github.com/webpulser/forgeos_core'

  s.files = Dir['{app,lib}/**/*', 'README*', 'LICENSE*']
end
