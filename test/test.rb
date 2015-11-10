gem 'simplecov', :require => false, :group => :test
require 'simplecov'
SimpleCov.start
gem "minitest"  
require 'minitest/autorun'
require 'teamcity-prisma'
#require 'C:/teamcity-prisma/lib/teamcity-prisma.rb'
require 'yaml'

class PrismaTest < Minitest::Test
  def setup
    File.delete('C:\Teamcity-Prisma\result_vcs_search_minor_than_60.yml') if File.exist?('C:\Teamcity-Prisma\result_vcs_search_minor_than_60.yml')
    File.delete('C:\Teamcity-Prisma\result_buildstep_search.yml') if File.exist?(':\Teamcity-Prisma\result_buildstep_search.yml')
    File.delete('C:\Teamcity-Prisma\result_buildstep_search.yml') if File.exist?(':\Teamcity-Prisma\result_buildstep_replace.yml')
  end
  
  #############################################################################################################
  ###
  ###     VCS ROOT          ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################
  def test_vcs_search_minor_than_60
    result = TeamcityPrisma::Core.new(['vcsroot_find', 'C:/Teamcity-Prisma/secret_constants.rb', 'dev', '60', 'minor_than', 'C:\Teamcity-Prisma\result_vcs_search_minor_than_60.yml'])   
    result = YAML::load_file('C:\Teamcity-Prisma\result_vcs_search_minor_than_60.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_vcs_search_minor_than_60.yml'))    
    assert_equal result, bed  
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP        ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################

  def test_buildstep_search
    result = TeamcityPrisma::Core.new(['property_search', 'C:/Teamcity-Prisma/secret_constants.rb', 'dev', 'iinstall', 'C:\Teamcity-Prisma\result_buildstep_search.yml'])
    result = YAML::load_file('C:\Teamcity-Prisma\result_buildstep_search.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_search.yml'))
    assert_equal result, bed
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       R  E  P  L  A  C  E      ----------
  ###
  ############################################################################################################# 
  
  def test_buildstep_replace
    TeamcityPrisma::Core.new(['property_replace', 'C:/Teamcity-Prisma/secret_constants.rb', 'dev', 'test_buildstep_replace_expected', 'test_buildstep_replace_modified', 'C:\Teamcity-Prisma\result_buildstep_replace.yml'])
    result = TeamcityPrisma::Core.new(['property_replace', 'C:/Teamcity-Prisma/secret_constants.rb','dev', 'test_buildstep_replace_modified', 'test_buildstep_replace_expected', 'C:\Teamcity-Prisma\result_buildstep_replace.yml'])
    result = YAML::load_file('C:\Teamcity-Prisma\result_buildstep_replace.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_replace.yml'))
    assert_equal result, bed
  end
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       M  O  D  I  F  Y     L  I  S  T  B  O  X      ----------
  ###
  #############################################################################################################
  
  def test_buildstep_modify
    TeamcityPrisma::Core.new(['property_modify', 'C:/Teamcity-Prisma/secret_constants.rb', 'dev','PS1', 'p', 'C:\Teamcity-Prisma\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
    result = TeamcityPrisma::Core.new(['property_modify', 'C:/Teamcity-Prisma/secret_constants.rb', 'dev','STDIN', 'e', 'C:\Teamcity-Prisma\result_buildstep_modify.yml', nil, 'PackageStoreAPI_TestTemplate'])
    result = YAML::load_file('C:\Teamcity-Prisma\result_buildstep_modify.yml')
    bed = YAML::load_file(File.join(File.dirname(__FILE__), 'bed_buildstep_modify.yml'))
    assert_equal result, bed 
  end
end
