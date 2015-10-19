require 'thwait'

module TeamcityPrisma
  class VCS
    @@params = ["-t", "vcs_root"]
    @@elements = Array.new
    $result = Array.new
    @@counter = 0
    @@contador = 0
    #def initialize
    #  print "VCSRoot.rb"
    #end
    
    
    def find_custom_period(site, seconds, operator)
      puts "seconds: #{seconds}    -     operator: #{operator}"
      @string = seconds
      @operator = operator
      TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{seconds}", "-o", "#{operator}", "-m", "search"])
    end
    
    
    def _find_custom_period
      vcs_roots = Array.new
      vcs_roots = TeamCity.vcs_roots
      total = TeamCity.vcs_roots.count
      
      @@blocks_total = 5.0
      blocks = Array.new
      blocks = vcs_roots.each_slice( (vcs_roots.size/@@blocks_total).round ).to_a
      threads = []
      blocks.each do |block|
        #print block.count.pretty_inspect()
        threads << Thread.new do
               _find_custom_period_property(block)  
              end                           
      end      
      ThreadsWait.all_waits(*threads)
      
      puts "\n\nTotal with a custom period: #{@@counter}\n\n"
            
      threads = []
      blocks = Array.new
      blocks = @@elements.each_slice( (@@elements.size/@@blocks_total).round ).to_a
      
      blocks.each do |block|        
        threads << Thread.new do
                   _find_custom_period_string(block)  
                 end               
      end      
      ThreadsWait.all_waits(threads)
      
      puts "\n\nTotal found: #{@@found}"      
      $result.flatten!()      
    
    end
    
    
    def _find_custom_period_property(vcs_roots)     
      
      #puts vcs_roots.pretty_inspect()
      total = vcs_roots.count
      fill = ""
      129.times do fill = fill + " " end

      vcs_roots.each do |vcs_root|
    
        
        print "#{@@counter*100/@@blocks_total.round/total}%#{9.chr}modificationCheckInterval: "
        80.times do print " " end
        print "\r"
        print "#{@@counter*100/@@blocks_total.round/total}%#{9.chr}modificationCheckInterval: #{vcs_root.id} \r"
        
        unless TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval.nil?
          @@elements.push(vcs_root)          
          print "#{vcs_root.id}" + fill + "\n"
        
        end  
       
        @@counter = @@counter + 1

      end
      
      150.times{print " "}
      print"\r" 
   
    end
    
    def _find_custom_period_string(elements)
      
      result = Array.new
      @@found = 0
      total = elements.count
      fill = ""
      65.times do fill = fill + " " end
      
      elements.each() do |element|
        
        print "#{@@contador*100/@@blocks_total.round/total}% compare: "
        90.times do print " " end
        print "\r"
        print "#{@@contador*100/@@blocks_total.round/total}% compare: #{element.id} \r"
        
        if compare(TeamCity.vcs_root_details(element.id).modificationCheckInterval, @string)
 
          result.push(element)
          print "#{element.id} - #{TeamCity.vcs_root_details(element.id).modificationCheckInterval}" + fill + "\n"
          
          @@found = @@found + 1
          
        end
        
        @@contador = @@contador + 1
        
      end
      80.times do print " " end 
      print "\r"
      
      
      $result << result
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
  end
end


