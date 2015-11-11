module TeamcityPrisma
  class Prisma
    def process(parameters)

      arguments = TeamcityPrisma::PrismaArguments.new(parameters)
      $site = arguments[:site]      
      testBuild = BuildType.new()

      $files = TeamcityPrisma::Files.new(arguments[:mode], arguments[:output])
        
      #LOAD CONSTANTS
      require arguments[:config]
      require File.join(File.dirname(__FILE__), 'RubyClient.rb')
      TeamcityPrisma::RubyClient.new().ConfigTeamcityAPI()    
      end
      
      def close_files
        $files.write_output($result)
        $files.close  
      end 
  end
end