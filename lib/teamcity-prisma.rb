require 'teamcity'
require "selenium-webdriver"
require "pp"
require "yaml"
require './teamcity-prisma/constants/constants.rb'
require './teamcity-prisma/constants/secret_constants.rb'
require './PrismaArguments.rb'
require './BuildType.rb'
require './RubyClient.rb'
require './Selenium.rb'
require './Project.rb'
require './VCS.rb'
require './teamcity-prisma/Files.rb'

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
    files.write_items(TeamCity.vcs_roots)
    
  
    
    
    case arguments[:type]
    when "build_type"
=begin
      ###########################################################################
      ###
      ###                                B U I L D S 
      ###
      ###########################################################################
      TeamCity.buildtypes.each do |build|
        #print build.keys
        print "\n"
        #print build["id"]
        print "\n"
        #print TeamCity.buildtype(id: build["id"] )
        #print TeamCity.buildtype(id: "PackageStoreAPI_TestTemplate" ).keys
        #print TeamCity.buildtype(id: "PackageStoreAPI_TestTemplate" )["template"].pretty_inspect()
        #print TeamCity.buildtype(id: build["id"] )["vcs-root-entries"].pretty_inspect()
        
        #print TeamCity.buildtype(id: build["id"] )["steps"]
        TeamCity.buildtype(id: build["id"])["steps"]["step"].each do |step|
          step["properties"]["property"].each do |prop|
            #print prop["value"]
            #print "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy\n"  
          end
          #print step["properties"].keys
          #print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
          
        end
        print "\n\n"
      end
      

      
      print "\n\n"
      #print TeamCity.buildtypes
      print "\n\n"
      
      print "BuildTypes: #{TeamCity.buildtypes.count}\n"
      print "Projects: #{TeamCity.projects.count}\n"
      #print "VCS Roots: #{TeamCity.vcs_roots.count}\n"
      
=end
      
      $prisma._find_string
      
      print "Completed BuildType process                                                                                \r\n"
    
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
    
=begin      
    #begin    
      
        
        
        TeamCity.vcs_roots.each do |vcs_root|
          #print TeamCity.vcs_root_details(vcs_root.id).properties.property("agentCleanFilesPolicy")
          print "                                                                                                     \r"
          print "#{vcs_root.id} - #{TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval} - #{arguments[:string].to_i}\r"
          
          unless TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval.nil?
            if TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval.to_i < arguments[:string].to_i
              print "\n#{TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval} \r" 
              
              puts "\n"
              puts "#{vcs_root.id} - #{TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval} - #{arguments[:string].to_i}"
              puts "\n"
              #TeamcityPrisma::VCS.new
              puts "\n\n"
            end
          end
          
        end
    #end
=end
        
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