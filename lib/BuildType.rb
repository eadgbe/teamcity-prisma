module TeamcityRuby
  
  class BuildType   
    Thread.abort_on_exception=true
    @@params = ['-t', 'build_type']
      
    def initialize
      $result = Array.new
      @@elements = Array.new
      @@steps = 0
    end
      
    def find_string(parameters)
      config = parameters[1]
      site = parameters[2]
      @string = parameters[3]
      @output = parameters[4]
      @step_type = parameters[5] or nil
      @operator = 'contains'
      prisma = TeamcityRuby::Prisma.new
      prisma.process(@@params + ['-S', "#{site}", '-s', "#{@string}", '-o', @operator, '-m', 'search', '-z', "#{@step_type}", '-O', @output, '-c', config])
      _get_items
      fill = ''
      80.times do fill = fill + ' ' end
      print fill + "\r\n"
      prisma.close_files()
    end
     
    def replace_string(parameters)
      config = parameters[1]
      site = parameters[2]
      @string = parameters[3]
      @new_string = parameters[4]
      @output = parameters[5]
      @step_type = parameters[6] or nil
      @operator = 'contains'
      prisma = TeamcityRuby::Prisma.new
      prisma.process(@@params + ['-S', "#{site}", '-s', "#{@string}", '-o', @operator, '-m', 'replace', '-z', "#{@step_type}", '-O', @output, '-c', config])
        
      _get_items
      fill = ''
      80.times do fill = fill + ' ' end
      print fill + "\r\n"  
      if $result.count() > 0
        _replace_string(site)
      end      
        
      prisma.close_files()   
    end
    
    def modify_listbox(parameters)
      config = parameters[1]
      site = parameters[2]
      @string = parameters[3]
      @new_string = parameters[4]
      @output = parameters[5]
      @step_type = parameters[6] or nil 
      @buildtype_id = parameters[7] or nil
      @operator = 'contains'
      prisma = TeamcityRuby::Prisma.new
      prisma.process(@@params + ['-S', "#{site}", '-s', "#{@string}", '-o', @operator, '-m', 'modify', '-z', "#{@step_type}", '-O', @output, '-c', config, '-b', @buildtype_id])
      _get_items
      fill = ''
      80.times do fill = fill + ' ' end
      print fill + "\r\n"
      if $result.count() > 0
        _replace_string(site, LISTBOX_PARAMETER, @buildtype_id)
      end
      prisma.close_files()
    end
    
    private 

    def _replace_string(site, listbox=nil, buildtypeid=nil)
      $WebInterface = TeamcityRuby::RemoteWriter.new(site)
      $WebInterface.replace(@string, @new_string, listbox, buildtypeid)     
    end  

    def _get_items    
      build_types = Array.new
      build_types = TeamCity.buildtypes 
      @@blocks_total = 10.0
      @@blocks_total = build_types.size if build_types.size < 5
      blocks = Array.new
      blocks = build_types.each_slice( (build_types.count/@@blocks_total).round ).to_a   
      threads = []
      blocks.each do |block|
        threads << Thread.new do
                     _get_steps_ignore_templates(block)
                   end                           
      end      
      ThreadsWait.all_waits(*threads)
      puts "Threads: #{@@blocks_total}"
      puts "Builds in total: #{build_types.count}"
      puts "Steps to analyze: #{@@steps} "        
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
      $result.flatten!()            
      puts "\n\nTotal of Items found: #{$result.count}"             
    end
    
    def _get_steps_ignore_templates(builds)
      counter = 0
      total = builds.count
      fill = ' '
      129.times do fill = fill + ' ' end
      builds.each do |build_type|
        print "#{counter*100/@@blocks_total.round/total}%#{9.chr}template?: "
              80.times do print ' ' end
              print "\r"
              print "#{counter*100/@@blocks_total.round/total}%#{9.chr}template?: #{build_type.id} \r"

        #While the script is running a build could be deleted. Prevent this situation.
        unless TeamCity.buildtype(id: "#{build_type.id}").nil?      
            
          #Collect all the steps of builds that are not based on Templates.             
          if TeamCity.buildtype(id: "#{build_type.id}")['template'].nil?                 
            steps = Array.new               
            unless TeamCity.buildtype(id: "#{build_type.id}")['steps']['step'].nil?
              counter = 0
              TeamCity.buildtype(id: "#{build_type.id}")['steps']['step'].each do |step|
                steps << counter
                counter = counter + 1
              end
            end      
            @@elements << { build_type_id: "#{build_type.id}", steps: steps } if steps.count > 0
            @@steps = @@steps + steps.count
            print "#{build_type.id}" + fill + "\n"
      
          #For builds based on templates ignore their inherited steps.  
          else      
            steps_template = Array.new    
            counter = 0
            unless TeamCity.buildtype_template(id: build_type.id)['steps']['step'].nil?
              
              TeamCity.buildtype_template(id: build_type.id)['steps']['step'].each do |step|
                steps_template << step.id
                counter = counter + 1
              end
            end
            steps = Array.new
            unless TeamCity.buildtype(id: "#{build_type.id}")['steps']['step'].nil?
              TeamCity.buildtype(id: "#{build_type.id}")['steps']['step'].each do |step|
                if !steps_template.include?(step.id)
                  steps << counter
                  counter = counter + 1
                end
              end
            end
            @@elements << { build_type_id: "#{build_type.id}", steps: steps } if steps.count > 0
            @@steps = @@steps + steps.count               
          end
        end            
        counter = counter + 1
      end
      150.times{print ' '}
      print"\r"     
    end
    
    def _get_properties(elements) 
      counter = 0   
      fill = ''
      65.times do fill = fill + ' ' end    
      elements.each() do |element|
        element[:steps].each do |step|
          if TeamCity.buildtype(id: element[:build_type_id])['steps']['step'][step] 
            TeamCity.buildtype(id: element[:build_type_id])['steps']['step'][step]['properties']['property'].each do |property| 
              if @step_type.nil? or _compare(property.name, @step_type)
                print "#{counter} of #{@@steps} steps, property: "     
                90.times do print ' ' end
                print "\r"
                print "#{counter} of #{@@steps} steps, property: #{property.name} \r"
                if _compare(property.value, @string)
                  $result << { build_type_id: "#{element[:build_type_id]}", step: step, property: property } 
                  print "#{element[:build_type_id]} -  #{property.name} " + fill + "\n"           
                end                
              end                     
            end
          end 
        counter = counter + 1  
        end
      end 
      80.times do print ' ' end 
      print "\r"
    end
  
    def _compare(x,y)
      case @operator
      when MINOR
        x.to_i < y.to_i
      when GREATER
        x.to_i > y.to_i
      when EQUALS
        x.to_i == y.to_i      
      when CONTAINS
        x.to_s.include?(y.to_s)
      else  
      end
    end  
  end
end