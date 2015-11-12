gem 'simplecov', :require => false, :group => :test
require 'simplecov'
SimpleCov.start
gem 'minitest'  
require 'minitest/autorun'
#require 'teamcity-ruby'
require 'C:/teamcity-ruby/lib/teamcity-ruby.rb'
require 'yaml'

class PrismaTest < Minitest::Test
  def setup
    File.delete('C:\Teamcity-Ruby\result_vcs_search_minor_than_60.yml') if File.exist?('C:\Teamcity-Ruby\result_vcs_search_minor_than_60.yml')
    File.delete('C:\Teamcity-Ruby\result_buildstep_search.yml') if File.exist?(':\Teamcity-Ruby\result_buildstep_search.yml')
    File.delete('C:\Teamcity-Ruby\result_buildstep_search.yml') if File.exist?(':\Teamcity-Ruby\result_buildstep_replace.yml')
  end
  
  #############################################################################################################
  ###
  ###     VCS ROOT          ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################
  def test_vcs_search_minor_than_60
    result = TeamcityRuby::Core.new(['vcsroot_find', 'C:/Teamcity-Ruby/config.rb', 'dev', '60', 'minor_than', 'C:\Teamcity-Ruby\result_vcs_search_minor_than_60.yml'])   
    result = YAML::load_file('C:\Teamcity-Ruby\result_vcs_search_minor_than_60.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_vcs_search_minor_than_60.yml'))    
    assert_equal result, bed  
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP        ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################

  def test_buildstep_search
    result = TeamcityRuby::Core.new(['property_search', 'C:/Teamcity-Ruby/config', 'dev', 'iinstall', 'C:\Teamcity-Ruby\result_buildstep_search.yml'])
    result = YAML::load_file('C:\Teamcity-Ruby\result_buildstep_search.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_search.yml'))
    assert_equal result, bed
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       R  E  P  L  A  C  E      ----------
  ###
  ############################################################################################################# 
  
  def test_buildstep_replace
    TeamcityRuby::Core.new(['property_replace', 'C:/Teamcity-Ruby/config.rb', 'dev', 'test_buildstep_replace_expected', 'test_buildstep_replace_modified', 'C:\Teamcity-Ruby\result_buildstep_replace.yml'])
    result = TeamcityRuby::Core.new(['property_replace', 'C:/Teamcity-Ruby/config.rb','dev', 'test_buildstep_replace_modified', 'test_buildstep_replace_expected', 'C:\Teamcity-Ruby\result_buildstep_replace.yml'])
    result = YAML::load_file('C:\Teamcity-Ruby\result_buildstep_replace.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_replace.yml'))
    assert_equal result, bed
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       M  O  D  I  F  Y     L  I  S  T  B  O  X      ----------
  ###
  #############################################################################################################
  
  def test_buildstep_modify
    TeamcityRuby::Core.new(['property_modify', 'C:/Teamcity-Ruby/config.rb', 'dev','PS1', 'p', 'C:\Teamcity-Ruby\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
    result = TeamcityRuby::Core.new(['property_modify', 'C:/Teamcity-Ruby/config.rb', 'dev','STDIN', 'e', 'C:\Teamcity-Ruby\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
    result = YAML::load_file('C:\Teamcity-Ruby\result_buildstep_modify.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_modify.yml'))
    assert_equal result, bed 
  end
end
