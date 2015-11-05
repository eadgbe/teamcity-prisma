gem "minitest"  
require 'minitest/autorun'
require 'teamcity-prisma'
require 'yaml'

class PrismaTest < Minitest::Test
  

  
  #############################################################################################################
  ###
  ###     VCS ROOT          ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################
  def test_vcs_search_minor_than_60
    
    
    result = TeamcityPrisma::Core.new(["vcsroot_find", 'C:/Teamcity-Prisma/secret_constants.rb', "dev", "60", "minor_than", 'C:\Teamcity-Prisma\result_vcs_search_minor_than_60.yml'])
      
    result = YAML::load_file('C:\Teamcity-Prisma\result_vcs_search_minor_than_60.yml')
      
    #testbed = [{"id" => "PackageStoreAPI_Features", "href" => "/httpAuth/app/rest/vcs-roots/id:PackageStoreAPI_Features", "name" => "development"}]
    
    testbed = YAML::load_file(File.join(File.dirname(__FILE__), 'test_vcs_search_minor_than_60.yml'))    

    assert_equal result, testbed
    

  end
  
  
  #############################################################################################################
  ###
  ###     BUILD STEP        ----------       S  E  A  R  C  H      ----------
  ###
  #############################################################################################################

  def test_buildstep_search

    
    result = TeamcityPrisma::Core.new(["property_search", 'C:/Teamcity-Prisma/secret_constants.rb', "dev", "installl", 'C:\Teamcity-Prisma\result_buildstep_search.yml'])
    
    result = YAML::load_file('C:\Teamcity-Prisma\result_buildstep_search.yml')
    
    #testbed = YAML::load_file(File.join(File.dirname(__FILE__), 'test_vcs_search_minor_than_60.yml'))
      
    #assert_equal result, testbed

    
  end
  
  
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       R  E  P  L  A  C  E      ----------
  ###
  ############################################################################################################# 
  
  def test_buildstep_replace
    #TeamcityPrisma::Core.new(["property_replace", 'C:/Teamcity-Prisma/secret_constants.rb',"dev","installl", "install", "result_prisma.txt"])
  end
  
  
  #############################################################################################################
  ###
  ###     BUILD STEP     ----------       M  O  D  I  F  Y     L  I  S  T  B  O  X      ----------
  ###
  #############################################################################################################
  
  def test_buildstep_modify
    #TeamcityPrisma::Core.new(["property_modify", 'C:/Teamcity-Prisma/secret_constants.rb', "dev","STDIN", "e", "result_prisma.txt"])
  end
  
  
end


=begin

#############################################################################################################
###
#############################################################################################################

#puts $result.pretty_inspect()
puts "#########################################################################\n\n"
time2 = Time.new
puts "Process time: "
puts Time.at(time2-time1).utc.strftime("%H:%M:%S")
puts "$result.count: #{$result.count}"


=end