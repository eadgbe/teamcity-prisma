module TeamcityPrisma
  
  class RemoteWriter

    def initialize(server)
      if server == SITE_DEV
        @url = URL_DEV
        @login = LOGIN_DEV   
      else
        @url = URL_TC1
        @login = LOGIN_TC1
      end
      
      @site = server      
      
    end
    
          
    def BuildType
      
      $WebClient = TeamcityPrisma::SeleniumDriver.new()
      $WebClient.login_teamcity(@login)
      $WebClient.replace(@string, @new_string, @url)
      $WebClient.close()
      
    end  
    
    

    
    
  end

end