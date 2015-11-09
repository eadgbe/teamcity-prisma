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
        puts "Type parameter doesn't match any valid option.\n parameters = #{parameters[0].pretty_inspect()}"  
      end
    end 
    
  end #Class end
end #Module end


#puts ARGV.pretty_inspect()

TeamcityPrisma::Core.new(ARGV) if ARGV.length() > 0