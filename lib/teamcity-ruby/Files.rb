module TeamcityRuby
  class Files
    def initialize(mode, output)
      @mode = mode
      create_output(output) 
    end
    
    def write_output(content)
      @output.write(content.to_yaml())
      puts 'writing output_file'
    end
    
    def close
      @output.close
      @output = nil
    end
    
    private
    
    def create_output(path)
      @output = File.open(path, 'w')
    end  
  end
end