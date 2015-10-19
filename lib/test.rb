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

$prisma = TeamcityPrisma::VCS.new
$prisma.find_custom_period("tc1", "501", "minor_than")





#############################################################################################################
###
###     BUILD STEP
###
#############################################################################################################

#$prisma = TeamcityPrisma::BuildType.new
#$prisma.find_string("dev","test")





puts $result.pretty_inspect()
time2 = Time.new
puts "Process time: "
puts Time.at(time2-time1).utc.strftime("%H:%M:%S")

