require 'rubygems'
require 'bundler/setup'

require 'teamcity'
require 'selenium-webdriver'
require 'pp'
require 'yaml'
require File.join(File.dirname(__FILE__), 'teamcity-ruby', 'constants/constants.rb')
require File.join(File.dirname(__FILE__), 'PrismaArguments.rb')
require File.join(File.dirname(__FILE__), 'BuildType.rb')
require File.join(File.dirname(__FILE__), 'Prisma.rb')
require File.join(File.dirname(__FILE__), 'SeleniumDriver.rb')
require File.join(File.dirname(__FILE__), 'VCS.rb')
require File.join(File.dirname(__FILE__), 'teamcity-ruby/Files.rb')
require File.join(File.dirname(__FILE__), 'RemoteWriter.rb')

module TeamcityRuby
  class Core
    def initialize(parameters)
      $errors = Array.new
      case parameters[0]
        when 'property_search'
           $prisma = TeamcityRuby::BuildType.new
           $prisma.find_string(parameters)   
        when 'property_replace'
           $prisma = TeamcityRuby::BuildType.new
           $prisma.replace_string(parameters)
        when 'property_modify'
           $prisma = TeamcityRuby::BuildType.new
           $prisma.modify_listbox(parameters)
        when 'vcsroot_find'
           $prisma = TeamcityRuby::VCS.new
           $prisma.find_custom_period(parameters)
      else
        puts "Type parameter doesn't match any valid option.\n parameters = #{parameters[0].pretty_inspect()}"  
      end
      puts "Errors:"
      puts $errors.pretty_print_inspect()
    end      
  end
end