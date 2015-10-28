module TeamcityPrisma
  
  class Writer
      
    def BuildType
      
      $Writer = TeamcityPrisma::SeleniumDriver.new()
      $Writer.login_teamcity(@login)
      #$Writer.replace(@string, @new_string)
      $Writer.close()
      
    end  
    
    
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
    
    
  end

end