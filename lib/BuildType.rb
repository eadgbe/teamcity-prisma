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
      
      puts build_types.count*0.002
      @@blocks_total = 10.0
      blocks = Array.new
      blocks = build_types.each_slice( (build_types.count/@@blocks_total).round ).to_a
      
      
     
      threads = []
      blocks.each do |block|
        print block.count.pretty_inspect()
        threads << Thread.new do
                     _get_steps_ignore_templates(block)
                   end                           
      end      
      ThreadsWait.all_waits(*threads)

      #_get_steps_ignore_templates(build_types)
      
      #puts @@elements.pretty_inspect
      puts "Builds in total: #{build_types.count}"
      puts "Builds to analyze: #{@@elements.count} "  
      
      
      $result = @@elements
      $result.flatten!()
      
      #blocks = Array.new
      #blocks = @@elements.each_slice( (@@elements.size/@@blocks_total).round ).to_a
      
      #puts "Number of blocks: #{blocks.count}"
      
      
    end
    
    
    
    def _get_steps_ignore_templates(builds)

      
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
        
        
       
        #While the script is running a build could be deleted. Prevent this situation.
        unless TeamCity.buildtype(id: "#{build_type.id}").nil?      
       
          
          #Collect all the steps of builds that are not based on Templates.             
          if TeamCity.buildtype(id: "#{build_type.id}")["template"].nil?
            
            steps = Array.new
            
            unless TeamCity.buildtype(id: "#{build_type.id}")["steps"]["step"].nil?
              TeamCity.buildtype(id: "#{build_type.id}")["steps"]["step"].each do |step|
                steps << step.id
              end
            end
            
            @@elements << { id: "#{build_type.id}", steps: steps } if steps.count > 0
          
              
        
            print "#{build_type.id}" + fill + "\n"
              
            
          #For builds based on templates ignore their inherited steps.  
          else
            
            steps_template = Array.new
            
            unless TeamCity.buildtype_template(id: build_type.id)["steps"]["step"].nil?
              TeamCity.buildtype_template(id: build_type.id)["steps"]["step"].each do |step|
                steps_template << step.id
              end
            end
            
            steps = Array.new
            
            TeamCity.buildtype(id: "#{build_type.id}")["steps"]["step"].each do |step|
              if !steps_template.include?(step.id)
                steps << step.id
              end
            end
            
                      
            @@elements << { id: "#{build_type.id}", steps: steps } if steps.count > 0
            
            
          end
        
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