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
    end
  end
end