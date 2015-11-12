# Teamcity-Ruby


CONFIGURATION

Create a config file based on the next template:


			module TeamcityRuby
			
			  URL_DEV = 'http://DEV_SERVER_URL'
			  URL_TC1 = 'https://PRODUCTION_SERVER_1_URL'
			  URL_TC2 = 'https://PRODUCTION_SERVER_2_URL'
			  URL_TC3 = 'https://PRODUCTION_SERVER_3_URL'
			  
			  LOGIN_DEV = 'http://DEV_SERVER_1_LOGIN_URL'
			  LOGIN_TC1 = 'https://PRODUCTION_SERVER_1_LOGIN_URL'
			  LOGIN_TC2 = 'https://PRODUCTION_SERVER_1_LOGIN_URL'
			  LOGIN_TC3 = 'https://PRODUCTION_SERVER_1_LOGIN_URL'
			  
			  USER_SVC = 'USER_NAME_USED_IN_ALL_THE_SERVERS'
			  PASS_SVC = 'PASSWORD_USED_IN_ALL_THE_SERVERS'
			 
			end  


INSTRUCTION

Install the gem:

  gem build .\teamcity-ruby.gemspec
  gem install .\teamcity-ruby-0.0.1.gem

Require:

  require 'teamcity-ruby'

FUNCTIONS

   vcsroot_find 
     Searches properties that contain the specified string. 
     Object: VCS roots.
    
     Parameters
       Function:  < vcsroot_find >
       Config file location : < path >
       Teamcity Server: < dev | tc1 | tc2 | tc3 >
       String: < string to be searched >
       Operator: < minor_than | greater_than | equals | contains >
       Output: < Path to the file that will store the results >
     
     Example:
     
       TeamcityRuby::Core.new(['vcsroot_find', 'C:/Teamcity-Ruby/config.rb', 'dev', '60', 'minor_than', 'C:\Teamcity-Ruby\result_vcs_search_minor_than_60.yml'])
       This example searches for VCS roots with a Checking interval minor to 60 seconds in the Dev server.
   
   property_search
     Searches properties that contain the specified string. 
     Object: BuildTypes.
     
     Parameters
       Function:  < property_search >
       Config file location : < path >
       Teamcity Server: < dev | tc1 | tc2 | tc3 >
       String: < string to be searched >
       Output: < Path to the file that will store the results >
     
     
     Example:
     
       TeamcityRuby::Core.new(['property_search', 'C:/Teamcity-Ruby/config', 'dev', 'iinstall', 'C:\Teamcity-Ruby\result_buildstep_search.yml'])
       This example searches for the word 'iinstall' (notice the double 'ii') in the properties inside of the steps that belong to the BuildType runners.
     
     
   property_replace. 
     First searches properties that contain the specified string and then replaces them with the new_string parameter.
     Object: BuildTypes.
     
     Parameters
       Function:  < property_replace >
       Config file location : < path >
       Teamcity Server: < dev | tc1 | tc2 | tc3 >
       String: < string to be searched >
       New String: < string that will replace the original string >
       Output: < Path to the file that will store the results >
     
     Example:
     
       TeamcityRuby::Core.new(['property_replace', 'C:/Teamcity-Ruby/config.rb', 'dev', 'test_buildstep_replace_expected', 'test_buildstep_replace_modified', 'C:\Teamcity-Ruby\result_buildstep_replace.yml'])
       This example searches for the String in the properties inside the steps that belong to the BuildType runners and then replace it with the New String.
   
   property_modify. 
     First searches properties that contain the specified string and then replaces them with the new_string parameter.
  
     Parameters
       Function:  < property_modify >
       Config file location : < path >
       Teamcity Server: < dev | tc1 | tc2 | tc3 >
       String: < string to be searched >
       New String: < string that will replace the original string >
       Output: < Path to the file that will store the results >   
       StepType: [ Step type, for reference of the step types refer to the Teamcity Documentation ]
       BuildType: [ ID of a specific BuildType ] 
    
     Example:
     
       TeamcityRuby::Core.new(['property_modify', 'C:/Teamcity-Ruby/config.rb', 'dev','PS1', 'p', 'C:\Teamcity-Ruby\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
       In a PowerShell step type, this example changes the value of the property 'Script execution mode'
