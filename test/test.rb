gem 'simplecov', :require => false, :group => :test
require 'simplecov'
SimpleCov.start
gem 'minitest'  
require 'minitest/autorun'
require 'teamcity-ruby'
#require '.\lib/teamcity-ruby.rb'
require 'yaml'
require 'statsd'

class PrismaTest < Minitest::Test
  def setup
    File.delete('.\result_vcs_search_minor_than_60.yml') if File.exist?('.\result_vcs_search_minor_than_60.yml')
    File.delete('.\result_buildstep_search.yml') if File.exist?(':\Teamcity-Ruby\result_buildstep_search.yml')
    File.delete('.\result_buildstep_search.yml') if File.exist?(':\Teamcity-Ruby\result_buildstep_replace.yml')
  end
  
  #############################################################################################################
  ###
  ###     VCS ROOT          ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################
  def test_vcs_search_minor_than_60
    result = TeamcityRuby::Core.new(['vcsroot_find', '.\config.rb', 'dev', '60', 'minor_than', '.\result_vcs_search_minor_than_60.yml'])   
    result = YAML::load_file('.\result_vcs_search_minor_than_60.yml')
    #Datagod Gauge
    if result.size() > 0    
      statsd = Statsd.new
      statsd.gauge('dev VCS roots minor than 60', result.count)
      puts "result.count : #{result.count}"
    end
    
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_vcs_search_minor_than_60.yml'))    
    assert_equal result, bed  
  end
  
  #TC1
  #TC2
  def test_vcs_search_minor_than_500
    result = TeamcityRuby::Core.new(['vcsroot_find', '.\config.rb', 'tc1', '500', 'minor_than', '.\result_vcs_search_minor_than_500_tc1.yml'])
    result = TeamcityRuby::Core.new(['vcsroot_find', '.\config.rb', 'tc2', '500', 'minor_than', '.\result_vcs_search_minor_than_500_tc2.yml'])     
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP        ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################

  def test_buildstep_search
    result = TeamcityRuby::Core.new(['property_search', '.\config', 'dev', 'iinstall', '.\result_buildstep_search.yml'])
    result = YAML::load_file('.\result_buildstep_search.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_search.yml'))
    assert_equal result, bed
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       R  E  P  L  A  C  E      ----------
  ###
  ############################################################################################################# 
  
  def test_buildstep_replace
    TeamcityRuby::Core.new(['property_replace', '.\config.rb', 'dev', 'test_buildstep_replace_expected', 'test_buildstep_replace_modified', '.\result_buildstep_replace.yml'])
    result = TeamcityRuby::Core.new(['property_replace', '.\config.rb','dev', 'test_buildstep_replace_modified', 'test_buildstep_replace_expected', '.\result_buildstep_replace.yml'])
    result = YAML::load_file('.\result_buildstep_replace.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_replace.yml'))
    assert_equal result, bed
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       M  O  D  I  F  Y     L  I  S  T  B  O  X      ----------
  ###
  #############################################################################################################
  
  def test_buildstep_modify
    TeamcityRuby::Core.new(['property_modify', '.\config.rb', 'dev','PS1', 'p', '.\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
    result = TeamcityRuby::Core.new(['property_modify', '.\config.rb', 'dev','STDIN', 'e', '.\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
    result = YAML::load_file('.\result_buildstep_modify.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_modify.yml'))
    assert_equal result, bed 
  end
end
