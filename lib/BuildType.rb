module TeamcityPrisma
  
  class BuildType
    @@params = ["-t", "build_type"]
    $result = Array.new
    @@elements = Array.new
    @@counter = 0
    
    def find_string(site, string)
      @string = string
      #TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{seconds}", "-o", "#{operator}", "-m", "search"])
      TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{string}", "-o", "contains", "-m", "search"])
    end
    
    
    def _find_string
      
      build_types = Array.new
      build_types = TeamCity.buildtypes
      
      @@blocks_total = 5.0
      blocks = Array.new
      blocks = build_types.each_slice( (build_types.count/@@blocks_total).round ).to_a
      
      
      
      threads = []
      blocks.each do |block|
        #print block.count.pretty_inspect()
        threads << Thread.new do
                     _find_string_ignore_templates(block)
                   end                           
      end      
      ThreadsWait.all_waits(*threads)
      
      #puts @@elements.pretty_inspect
      puts "Builds in total: #{build_types.count}"
      puts "Builds to analyze: #{@@elements.count} "  
      
      
     
      
      
      #blocks = Array.new
      #blocks = @@elements.each_slice( (@@elements.size/@@blocks_total).round ).to_a
      
      #puts "Number of blocks: #{blocks.count}"
      
      
    end
    
    
    
    def _find_string_ignore_templates(builds)

      
      #puts TeamCity.buildtype(id:'PackageStoreAPI_Master').steps.pretty_inspect()
      #puts build_types.pretty_inspect()
      
      # Ignore build_types based on Templates.

      
      total = builds.count
      fill = " "
      129.times do fill = fill + " " end
      
      #puts ">>>>>>>>>>>> total builds #{total}"
        
      builds.each do |build_type|
        
        #puts ">>>>>>>>>>>> #{build_type.id}" 
        
        #cli_percentage(@@counter, @@blocks_total, "template?", build_type.id)
        print "#{@@counter*100/@@blocks_total.round/total}%#{9.chr}template?: "
              80.times do print " " end
              print "\r"
              print "#{@@counter*100/@@blocks_total.round/total}%#{9.chr}template?: #{build_type.id} \r"
        
        
        if TeamCity.buildtype(id: "#{build_type.id}")["template"].nil?
          @@elements << TeamCity.buildtype(id: "#{build_type.id}")
          print "#{build_type.id}" + fill + "\n"
        end
        @@counter = @@counter + 1
      end
      
      150.times{print " "}
      print"\r"
      
         
    end
    
    
    
    
    
    
    def cli_percentage(counter, blocks_total, message, message1)
      
      print "#{counter*100/blocks_total.round/total}%#{9.chr}#{message}: "
      80.times do print " " end
      print "\r"
      print "#{counter*100/blocks_total.round/total}%#{9.chr}#{message}: #{message} \r"
    end
    
    
    
    
  end

end