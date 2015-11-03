
module TeamcityPrisma
  class SeleniumDriver
    
    

    
     def initialize()
     
        @@client = Selenium::WebDriver::Remote::Http::Default.new
        @@client.timeout = 240 # seconds
        @@driver = Selenium::WebDriver.for(:firefox, :http_client => @@client)
        @@driver.manage.timeouts.implicit_wait = 60 # seconds
               
     end
     
     def close
       @@driver.quit
     end
     
     def replace(string, new_string, url, listbox = nil)
       
       $result.each() do |result|
         result[:property].name
         runner =  TeamCity.buildtype(id: result[:build_type_id])["steps"]["step"][result[:step]].id

         unless runner.nil? 
           @@driver.navigate.to "#{url}/admin/editRunType.html?id=buildType:#{result[:build_type_id]}&runnerId=#{runner}"
         
           wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
           wait.until { @@driver.find_element(:id, result[:property].name)  }
           html_element = @@driver.find_element(:id, result[:property].name)
             
           #value = html_element.text
           value = result[:property].value
           value = value.gsub(/#{string}/, new_string)
           html_element.clear
           html_element.send_keys value
           
             if !listbox.nil? and listbox.include?("listbox")                            
               begin
                 wait.until {@@driver.find_element(:name, 'prop:'+result[:property].name)}
                 html_element = @@driver.find_element(:name, 'prop:'+result[:property].name)
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
           
           @@driver.find_element(:name, 'submitButton').click
           
           wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
           wait.until {
             @@driver.find_element(:id, 'unprocessed_buildRunnerSettingsUpdated')
           }
           
         else
           next
         end
       
       end
       
       
       
       
       
       
       
     end
     
     
     def submit
       @@driver.find_element(:name, 'submitButton').click

       wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
       wait.until {
         @@driver.find_element(:id, 'unprocessed_buildRunnerSettingsUpdated')
       }
     end
     
     def find_element(name, element)
       
       @@driver.find_element(name, element)
       
     end
     
     
     def send_keys
       @@html_element.send_keys property_value
     end
     
     
    def login_teamcity(url, username=nil, password=nil)
      @@driver.navigate.to url
      begin
        if find_element('name', 'username')
          html_element = find_element('name', 'username')
          html_element.send_keys USER_TC1
          pass = find_element('name', 'password')
          pass.send_keys PASS_TC1
          html_element.submit
        end
      rescue       
      end
      
    end 
  end
end