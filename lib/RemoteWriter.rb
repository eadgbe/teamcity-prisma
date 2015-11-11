module TeamcityPrisma
  class RemoteWriter
    def initialize(server)  
      case server 
      when SITE_DEV
        @url = URL_DEV
        @login = LOGIN_DEV
      when SITE_TC1
        @url = URL_TC1
        @login = LOGIN_TC1
      when SITE_TC2
        @url = URL_TC2
        @login = LOGIN_TC2
      when SITE_TC3
        @url = URL_TC3
        @login = LOGIN_TC3
      else 
        puts 'The Site has not been spec.'
      end                
      @site = server      
    end  
          
    def Replace(string, new_string, listbox=nil, buildtypeid=nil)   
      $seleniumDriver = TeamcityPrisma::SeleniumDriver.new()
      $seleniumDriver.login_teamcity(@login)
      $seleniumDriver.replace(string, new_string, @url, listbox, buildtypeid)
      $seleniumDriver.close() 
    end      
  end
end