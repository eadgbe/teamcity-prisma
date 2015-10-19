require './teamcity-prisma/constants/constants.rb'
require './teamcity-prisma/constants/secret_constants.rb'

module TeamcityPrisma
  class RubyClient

    def ConfigTeamcityAPI
    
      # This only needs to be set once per Ruby execution.
      # You may use guestAuth instead of httpAuth and omit the use of http_user and http_password
      # This is using the latest version of the api
      puts "RubyClient.rb"
      puts $site

      TeamCity.configure do |config|
        case $site 
        when "dev"
          config.endpoint = "#{URL_DEV}/httpAuth/app/rest"
          config.http_user = USER_DEV
          config.http_password = PASS_DEV    
        when "tc1"
          config.endpoint = "#{URL_TC1}/httpAuth/app/rest"
          config.http_user = USER_TC1
          config.http_password = PASS_TC1
        when "tc2"
          config.endpoint = "#{URL_TC2}/httpAuth/app/rest"
          config.http_user = USER_TC2
          config.http_password = PASS_TC2
        when "tc3"
          config.endpoint = "#{URL_TC3}/httpAuth/app/rest"
          config.http_user = USER_TC3
          config.http_password = PASS_TC3          
        else 
          puts "The Site has not been spec."
        end
      end
      
=begin      
        @@client = Selenium::WebDriver::Remote::Http::Default.new
        @@client.timeout = 240 # seconds
        @@driver = Selenium::WebDriver.for(:firefox, :http_client => @@client)
        @@driver.manage.timeouts.implicit_wait = 60 # seconds
=end
      
    end
  end
end