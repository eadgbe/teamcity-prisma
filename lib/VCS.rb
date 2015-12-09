require 'thwait'

module TeamcityRuby
  class VCS
    @@params = ['-t', 'vcs_root']
      
    def initialize
      @@elements = Array.new    
      $result = Array.new
    end
    
    def find_custom_period(parameters)
      config = parameters[1]
      site = parameters[2]
      @string = parameters[3]
      @operator = parameters[4]
      @output = parameters[5]
      prisma = TeamcityRuby::Prisma.new
      prisma.process(@@params + ['-S', "#{site}", '-s', "#{@string}", '-o', "#{@operator}", '-m', 'search', '-O', @output, '-c', config])
      _get_items
      prisma.close_files()
      fill = ''
      80.times do fill = fill + ' ' end
      print fill + "\r\n"
    end
    
    private
    
    def _get_items
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
      
      puts "\n\nTotal of VCS with a custom period: #{@@elements.size}\n\n"
            
      @@blocks_total = @@elements.size if @@elements.size < 5
      threads = []
      blocks = Array.new
      blocks = @@elements.each_slice( (@@elements.size/@@blocks_total).round ).to_a
      
      blocks.each do |block|        
        threads << Thread.new do
                   _find_custom_period_string(block)  
                 end               
      end      
      ThreadsWait.all_waits(threads)
         
      $result.flatten!()
      puts "\n\nTotal of items found: #{$result.count}"
      puts $result.pretty_inspect()        
    end   
    
    def _find_custom_period_property(vcs_roots)  

      counter = 0      
      total = vcs_roots.count
      fill = ''
      129.times do fill = fill + ' ' end

      vcs_roots.each do |vcs_root|   
        
        if $debug_print
          print "#{counter*100/@@blocks_total.round/total}%#{9.chr}modificationCheckInterval: "
          80.times do print ' ' end
          print "\r"
          print "#{counter*100/@@blocks_total.round/total}%#{9.chr}modificationCheckInterval: #{vcs_root.id} \r"
        end
        
        unless TeamCity.vcs_root_details(vcs_root.id).modificationCheckInterval.nil?
          @@elements.push(vcs_root)     
          if $debug_print     
            print "#{vcs_root.id}" + fill + "\n"
          else
            print '.'
          end        
        end              
        counter = counter + 1
      end
      if $debug_print        
        150.times{print ' '}
        print"\r"
      end
    end
    
    def _find_custom_period_string(elements)     
      counter = 0
      result = Array.new
      total = elements.count
      fill = ''
      65.times do fill = fill + ' ' end
     
      elements.each() do |element|
        if $debug_print     
          print "#{counter*100/@@blocks_total.round/total}% compare: "
          90.times do print ' ' end
          print "\r"
          print "#{counter*100/@@blocks_total.round/total}% compare: #{element.id} \r"
        end       
        if _compare(TeamCity.vcs_root_details(element.id).modificationCheckInterval, @string)
          result.push(element)
          if $print_debug
            print "#{element.id} - #{TeamCity.vcs_root_details(element.id).modificationCheckInterval}" + fill + "\n"
          else
            print '.'
          end
        end         
        counter = counter + 1     
      end
      if $debug_print
        80.times do print ' ' end 
        print "\r"    
      end
      $result << result
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