module TeamcityRuby
  class RubyClient

    def ConfigTeamcityAPI
    
      # This only needs to be set once per Ruby execution.
      # You may use guestAuth instead of httpAuth and omit the use of http_user and http_password
      # This is using the latest version of the api
      TeamCity.configure do |config|
        case $site 
        when SITE_DEV
          url = URL_DEV + REST_LOCATION
        when SITE_TC1
          url = URL_TC1 + REST_LOCATION
        when SITE_TC2
          url = URL_TC2 + REST_LOCATION
        when SITE_TC3
          url = URL_TC3 + REST_LOCATION       
        else 
          puts 'The Site has not been spec.'
        end
        config.endpoint = url
        config.http_user = USER_SVC
        config.http_password = PASS_SVC 
      end
    end
  end
end