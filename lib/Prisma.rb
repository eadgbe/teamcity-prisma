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
      
      case arguments[:type]
      when "build_type"
  
        ###########################################################################
        ###
        ###                                B U I L D S 
        ###
        ###########################################################################          
        case arguments[:mode] 
        when "search"
          $prisma._find_string
          print "                                                                                \r\n"
        when "replace"
          $prisma._find_string
          print "                                                                                \r\n"  
          if $result.count() > 0
            $prisma._replace_string(arguments[:site])
          end      
          
        when "modify"
          $prisma._find_string
          print "                                                                                \r\n"
          if $result.count() > 0
            $prisma._replace_string(arguments[:site], "listbox", arguments[:buildtype_id])
          end
        else
          puts "search mode not valid"
        end        
      
        when "project"
        ###########################################################################
        ###
        ###                             P R O J E C T S 
        ###
        ###########################################################################         
        TeamCity.projects.each do |project|
          TeamcityPrisma::Project.new
        end    
          
        when "vcs_root"
        ###########################################################################
        ###
        ###                            V C S _ R O O T S 
        ###
        ########################################################################### 
        $files.write_items(TeamCity.vcs_roots)  
        $prisma._find_custom_period
        print "Completed                                                                                         \r\n"
          
        else
          puts "Type parameter doesn't match any valid option. arguments[:mode] = #{arguments[:mode]}"  
        end
        
        $files.write_found($result)
        $files.write_output($result)
        $files.close    
      end 
  end
end