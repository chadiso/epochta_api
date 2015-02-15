Gem::Specification.new do |s|
  s.name        = 'e_pochta'
  s.version     = '0.6.1'
  s.date        = '2013-06-01'
  s.summary     = "Ruby gem for EPochta API 3.0"
  s.description = "Ruby gem for EPochta API 3.0 - an email and sms service www.epochta.ru"
  s.authors     = ["Tim Tikijian"]
  s.email       = 'timurt1988@gmail.com'
  s.files       = Dir['lib/*.rb'] + Dir['test/*.rb'] + ['README.md']
  s.add_dependency('addressable' , '~> 2.2.8')
  s.homepage    =
    'http://rubygems.org/gems/e_pochta'
end