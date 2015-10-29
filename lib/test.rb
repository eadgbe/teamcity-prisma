#require 'minitest/autorun'
require './teamcity-prisma.rb'

=begin

class PrismaTest < Minitest::Test
  def test_development_server
    assert_equal "test", 
  end
end

=end

time1 = Time.new

#############################################################################################################
###
###     VCS ROOT
###
#############################################################################################################

#$prisma = TeamcityPrisma::VCS.new
#$prisma.find_custom_period("dev", "3601", "minor_than")





#############################################################################################################
###
###     BUILD STEP        ----------       S  E  A  R  C  H      ----------
###
#############################################################################################################

#$prisma = TeamcityPrisma::BuildType.new

####$prisma.find_string("tc2","test") #  search in all the build steps
#####$prisma.find_string("tc2","test", "script.content")

#$prisma.find_string("dev","bundle install") #  search in all the build steps



#############################################################################################################
###
###     BUILD STEP     ----------       R  E  P  L  A  C  E      ----------
###
#############################################################################################################

$prisma = TeamcityPrisma::BuildType.new
$prisma.replace_string("tc2","bundle install", "bundle install") #  search in all the build steps




#############################################################################################################
###
#############################################################################################################

#puts $result.pretty_inspect()
puts "#########################################################################\n\n"
time2 = Time.new
puts "Process time: "
puts Time.at(time2-time1).utc.strftime("%H:%M:%S")
puts "$result.count: #{$result.count}"

