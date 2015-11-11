module TeamcityPrisma
  class SeleniumDriver  
     def initialize()
        @@client = Selenium::WebDriver::Remote::Http::Default.new
        @@client.timeout = 240 # seconds
        @@driver = Selenium::WebDriver.for(:firefox, :http_client => @@client)
        @@driver.manage.timeouts.implicit_wait = 10 # seconds        
     end
     def close
       @@driver.quit
     end
     
     def replace(string, new_string, url, listbox = nil, buildtypeid=nil)
       $result.each() do |result|
         result[:property].name
         runner =  TeamCity.buildtype(id: result[:build_type_id])['steps']['step'][result[:step]].id   
         unless buildtypeid.nil? 
           unless result[:build_type_id].include?(buildtypeid)
             next
           end
         end
         unless runner.nil? 
           @@driver.navigate.to "#{url}/admin/editRunType.html?id=buildType:#{result[:build_type_id]}&runnerId=#{runner}"
                    
           wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds          
           
           value = result[:property].value
           value = value.gsub(/#{string}/, new_string)

           
             if !listbox.nil? and listbox.include?('listbox')                            
               begin
                 wait.until {@@driver.find_element(:name, PROPERTY_PREFIX + result[:property].name)}
                 html_element = @@driver.find_element(:name, PROPERTY_PREFIX + result[:property].name)
                 html_element.send_keys value
               rescue
               end
               
             else
               begin
                   
                 wait.until {@@driver.find_element(:id, result[:property].name)}
                 html_element = @@driver.find_element(:id, result[:property].name)
                 html_element.clear  
                 html_element.send_keys value
               rescue
               end
             end           
           
           wait.until {@@driver.find_element(:name, 'save')}
           @@driver.find_element(:name, 'save').click
           
           wait.until {@@driver.find_element(:id, 'unprocessed_buildRunnerSettingsUpdated')}          
           
         else
           next
         end      
       end               
     end
     
    def login_teamcity(url, username=nil, password=nil)
      @@driver.navigate.to url
      begin
        wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
        wait.until {@@driver.find_element('id', 'headerSearchField')}
      
      rescue 
        wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
        wait.until {@@driver.find_element('name', 'username')}
        html_element = @@driver.find_element('name', 'username')

        html_element.send_keys USER_TC1
        pass = @@driver.find_element('name', 'password')
        pass.send_keys PASS_TC1
        html_element.submit      
      end
      
    end 
  end
end