module TeamcityPrisma
  
  class BuildType
    
    Thread.abort_on_exception=true
    @@params = ["-t", "build_type"]
    $result = Array.new
    @@elements = Array.new
    @@counter = 0
    @@contador = 0
    @@found = 0
    @@steps = 0
    
    def find_string(site, string, step_type=nil)
      @string = string
      @step_type = step_type
      @operator = "contains"
      #TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{seconds}", "-o", "#{operator}", "-m", "search"])
      TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{string}", "-o", @operator, "-m", "search", "-z", "#{step_type}"])
    end
    
    
    def replace_string(site, string, new_string, step_type=nil)
      @string = string
      @new_string = new_string
      @step_type = step_type
      @operator = "contains"
      TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{string}", "-o", @operator, "-m", "replace", "-z", "#{step_type}"])
    end
    
    def _replace_string(site)
      puts "will start replacing"
      $Replace = TeamcityPrisma::RemoteWriter.new(site)
      $Replace.BuildType(@string, @new_string)     
    end
    
    
    def _find_string
      
      build_types = Array.new
      build_types = TeamCity.buildtypes
      
      puts build_types.count*0.002
      # 10.0 acceptable by tc1.
      @@blocks_total = 10.0
      @@blocks_total = build_types.size if build_types.size < 5
      blocks = Array.new
      blocks = build_types.each_slice( (build_types.count/@@blocks_total).round ).to_a
      
      puts build_types.count
      puts blocks.count
      threads = []
      blocks.each do |block|
        
        threads << Thread.new do
                     _get_steps_ignore_templates(block)
                   end                           
      end      
      ThreadsWait.all_waits(*threads)

      #_get_steps_ignore_templates(build_types)
      
      #puts @@elements.pretty_inspect
      puts "Threads: #{@@blocks_total}"
      puts "Builds in total: #{build_types.count}"
      puts "Steps to analyze: #{@@steps} "  
      
   
        #$result = @@elements
        #$result.flatten!()
      
#=begin
      
        
        @@blocks_total = @@elements.size if @@elements.size < 5
        threads = []
        blocks = Array.new
        blocks = @@elements.each_slice( (@@elements.size/@@blocks_total).round ).to_a
           

        blocks.each do |block|        
          threads << Thread.new do
                     _get_properties(block)  
                   end               
        end  
            
        ThreadsWait.all_waits(threads)
              
        
   
      
      puts "\n\nTotal found: #{@@found}"      
      $result.flatten!()            
    
        
#=end      
      
      
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

#=begin
        
                
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
              counter = 0
              TeamCity.buildtype(id: "#{build_type.id}")["steps"]["step"].each do |step|
                steps << counter
                counter = counter + 1
              end
            end
            
            $files.write_items({ build_type_id: "#{build_type.id}", steps: steps }) if steps.count > 0
            @@elements << { build_type_id: "#{build_type.id}", steps: steps } if steps.count > 0
            @@steps = @@steps + steps.count
          
              
        
            print "#{build_type.id}" + fill + "\n"
              
             
      
      
          #For builds based on templates ignore their inherited steps.  
          else
            
            steps_template = Array.new
            
            counter = 0
            unless TeamCity.buildtype_template(id: build_type.id)["steps"]["step"].nil?
              
              TeamCity.buildtype_template(id: build_type.id)["steps"]["step"].each do |step|
                steps_template << step.id
                counter = counter + 1
              end
            end
            
            steps = Array.new
            
           
            TeamCity.buildtype(id: "#{build_type.id}")["steps"]["step"].each do |step|
              if !steps_template.include?(step.id)
                steps << counter
                counter = counter + 1
              end
            end
            
                      
            $files.write_items( { build_type_id: "#{build_type.id}", steps: steps }) if steps.count > 0
            
            @@elements << { build_type_id: "#{build_type.id}", steps: steps } if steps.count > 0
            @@steps = @@steps + steps.count
           
                       
          end
        
        end
                
        @@counter = @@counter + 1
        
#=end
      end
      
      150.times{print " "}
      print"\r"
      
         
    end
    
    
    
    
    
    
    
    
  def _get_properties(elements)
             
       fill = ""
       65.times do fill = fill + " " end
       
       elements.each() do |element|
         
         #puts element[:steps].pretty_inspect()
                  
         element[:steps].each do |step|
         
           if TeamCity.buildtype(id: element[:build_type_id])["steps"]["step"][step]
           
             TeamCity.buildtype(id: element[:build_type_id])["steps"]["step"][step]["properties"]["property"].each do |property| 
             
               #if property.name.include?(@step_type)
               if @step_type.nil? or compare(property.name, @step_type)
                 
                 total = @@steps
    
                 #puts "stp: #{step} : comparacion #{property["value"].pretty_inspect()} - #{@string}"
                 
                 #puts "#{@@contador}*100 / #{@@blocks_total} / #{total} -  \n\n\n\n"
             
                 print "#{@@contador} of #{@@steps} steps, property: "
                 
                 90.times do print " " end
                 print "\r"
                 print "#{@@contador} of #{@@steps} steps, property: #{property.name} \r"
                                 
                 
                 if compare(property.value, @string)
                   
                   $result << { build_type_id: "#{element[:build_type_id]}", step: step, property: property } 
                   print "#{element[:build_type_id]} -  #{property.name} " + fill + "\n"
                   
                   @@found = @@found + 1
                   
                 end              
               
               end                     
             
             end
           
           end 
         @@contador = @@contador + 1  
         
         end
       
       
       end 
       
       
       
       80.times do print " " end 
       print "\r"

 
   end
    
    
    
    
    
 
    
    
    
    
  def compare(x,y)
    case @operator
    when 'minor_than'
      x.to_i < y.to_i
      
    when 'greater_than'
      x.to_i > y.to_i
      
    when 'equals'
      
      x.to_i == y.to_i
      
    when 'contains'
      x.to_s.include?(y.to_s)
    else
    
    end
  end  
    
    
    def cli_percentage(counter, blocks_total, message, message1)
      
      print "#{counter*100/blocks_total.round/total}%#{9.chr}#{message}: "
      80.times do print " " end
      print "\r"
      print "#{counter*100/blocks_total.round/total}%#{9.chr}#{message}: #{message} \r"
    end
    
    
    
    
  end

end