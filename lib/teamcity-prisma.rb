require 'teamcity'
require "selenium-webdriver"
require "pp"
require "yaml"
require './teamcity-prisma/constants/constants.rb'
require './teamcity-prisma/constants/secret_constants.rb'
require './PrismaArguments.rb'
require './BuildType.rb'
require './RubyClient.rb'
require './SeleniumDriver.rb'
require './Project.rb'
require './VCS.rb'
require './teamcity-prisma/Files.rb'
require './RemoteWriter.rb'

module TeamcityPrisma
  
#class Teamcity_Prisma
  
#end

class Core
  
  def initialize(parameters)
    puts "log: parameters #{parameters}"
    #arguments = TeamcityPrisma::PrismaArguments.new(ARGV)
    arguments = TeamcityPrisma::PrismaArguments.new(parameters)
    
    puts "prism.rb"
    puts arguments.pretty_inspect
    $site = arguments[:site]
    #puts $site
  
  
    TeamcityPrisma::RubyClient.new().ConfigTeamcityAPI()
    #TeamcityPrisma::SeleniumDriver.new().Driver()
  
    #TeamcityPrisma::Project.new().Query()
    
    testBuild = BuildType.new()
    
    
  
    
    #print TeamCity.vcs_roots[0]
    #print TeamCity.projects[0].pretty_inspect
    
    
    files = TeamcityPrisma::Files.new(arguments[:mode])
    
    
  
    
    
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
        print "Completed BuildType process                                                                                \r\n"
      when "replace"
        $prisma._find_string
        print "Completed BuildType process                                                                                \r\n"
        
        $prisma._replace_string(arguments[:site])
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
          #print project.pretty_inspect
          TeamcityPrisma::Project.new
        end    
        
      when "vcs_root"
      ###########################################################################
      ###
      ###                            V C S _ R O O T S 
      ###
      ###########################################################################
    
      files.write_items(TeamCity.vcs_roots)  
      $prisma._find_custom_period
    
     
      #puts TeamCity.vcs_root_details("Xunit_Bang").pretty_inspect
      #puts TeamCity.vcs_root_details("PackageStoreAPI_Maste").pretty_inspect
        print "Completed                                                                                         \r\n"
        
      else
        puts "Type parameter doesn't match any valid option"  
      end
      
      files.write_found($result)
      files.close
    
    end   

  end
end #Module end


#puts ARGV.pretty_inspect()

TeamcityPrisma::Core.new(ARGV) if ARGV.length() > 0