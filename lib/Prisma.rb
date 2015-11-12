module TeamcityRuby
  class Prisma
    def process(parameters)

      arguments = TeamcityRuby::PrismaArguments.new(parameters)
      $site = arguments[:site]      
      testBuild = BuildType.new()

      $files = TeamcityRuby::Files.new(arguments[:mode], arguments[:output])
        
      #LOAD CONSTANTS
      require arguments[:config]
      require File.join(File.dirname(__FILE__), 'RubyClient.rb')
      TeamcityRuby::RubyClient.new().ConfigTeamcityAPI()    
      end
      
    def close_files
      $files.write_output($result)
      $files.close  
    end 
  end
end