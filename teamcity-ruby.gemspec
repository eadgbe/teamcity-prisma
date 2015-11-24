Gem::Specification.new do |s|
  s.name        = 'teamcity-ruby'
  s.version     = '0.0.1'
  s.date        = '2015-10-07'
  s.summary     = "TeamCity Ruby"
  s.description = "Framework to access and modify TeamCity elements including Runners"
  s.authors     = ["Mariano Flores"]
  s.email       = 'mariano.flores@xero.com'
  s.files       = ["lib/BuildType.rb", "lib/Prisma.rb", "lib/PrismaArguments.rb", "lib/RemoteWriter.rb", "lib/RubyClient.rb", "lib/SeleniumDriver.rb", "lib/teamcity-ruby.rb", "lib/VCS.rb", "lib/teamcity-ruby/constants/constants.rb", "lib/teamcity-ruby/Files.rb"]
  s.homepage    = 'https://github.dev.xero.com/Xero/teamcity-ruby'
  s.license       = 'MIT'
  
  
  s.add_runtime_dependency 'simplecov', '>= 0.10.0'
  s.add_runtime_dependency 'teamcity-ruby-client', '~> 1.3.0'
  s.add_runtime_dependency 'selenium-webdriver', '~> 2.48.0'
  s.add_runtime_dependency 'minitest', '~> 5.8.0'
  s.add_runtime_dependency 'dogstatsd-ruby', '~> 1.5.0'
  
end