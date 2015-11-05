require 'teamcity'
require "selenium-webdriver"
require "pp"
require "yaml"
require File.join(File.dirname(__FILE__), 'teamcity-prisma', 'constants/constants.rb')
#require File.join(File.dirname(__FILE__), 'teamcity-prisma/constants/secret_constants.rb')
require File.join(File.dirname(__FILE__), 'PrismaArguments.rb')
require File.join(File.dirname(__FILE__), 'BuildType.rb')
require File.join(File.dirname(__FILE__), 'Prisma.rb')
require File.join(File.dirname(__FILE__), 'SeleniumDriver.rb')
require File.join(File.dirname(__FILE__), 'Project.rb')
require File.join(File.dirname(__FILE__), 'VCS.rb')
require File.join(File.dirname(__FILE__), 'teamcity-prisma/Files.rb')
require File.join(File.dirname(__FILE__), 'RemoteWriter.rb')

module TeamcityPrisma
  
#class Teamcity_Prisma
  
#end

class Core
  
  def initialize(parameters)
    puts "log: parameters #{parameters}"
    case parameters[0]
    when "property_search"
       $prisma = TeamcityPrisma::BuildType.new
       $prisma.find_string(parameters)
       
    when "property_replace"
       $prisma = TeamcityPrisma::BuildType.new
       $prisma.replace_string(parameters)
    when "property_modify"
       $prisma = TeamcityPrisma::BuildType.new
       $prisma.modify_listbox(parameters)
    when "vcsroot_find"
       $prisma = TeamcityPrisma::VCS.new
       $prisma.find_custom_period(parameters)
    else
      puts "Type parameter doesn't match any valid option"  
    end
  end
  
  def process(parameters)
    
    
    #arguments = TeamcityPrisma::PrismaArguments.new(ARGV)
    arguments = TeamcityPrisma::PrismaArguments.new(parameters)
    
    puts "prism.rb"
    puts arguments.pretty_inspect
    $site = arguments[:site]
    #puts $site
  
  
    #TeamcityPrisma::SeleniumDriver.new().Driver()
  
    #TeamcityPrisma::Project.new().Query()
    
    testBuild = BuildType.new()
    
    
  
    
    #print TeamCity.vcs_roots[0]
    #print TeamCity.projects[0].pretty_inspect
    
    
    files = TeamcityPrisma::Files.new(arguments[:mode])
    $files = TeamcityPrisma::Files.new(arguments[:mode], arguments[:output])
    
    
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
        print "Completed BuildType process                                                                                \r\n"
      when "replace"
        $prisma._find_string
        print "Completed BuildType process                                                                                \r\n"
        
        $prisma._replace_string(arguments[:site])
      when "modify"
        $prisma._find_string
        print "                                                                                \r\n"
        $prisma._replace_string(arguments[:site], "listbox")
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