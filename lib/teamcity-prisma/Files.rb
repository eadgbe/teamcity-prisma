module TeamcityPrisma
  class Files
    def initialize(mode, output)
      @mode = mode
      case @mode
      when "search"
        create_items()
        create_found()
        create_output(output)
        
      else       

        create_items()
        create_found()
        create_output(output)
        create_replace()
        create_processed()

      end      
    end
    
    def create_items()
      @items = File.open(FILE_ITEMS, "w")
      puts "creating items_file"
    end
    
    def write_items(content)
      @items.write(content.to_yaml())
    end
    
    def create_found()
      @found = File.open(FILE_FOUND, "w")
    end
    
    def write_found(content)
      @found.write(content.to_yaml())
      puts "writing found_file"
    end
    
    def create_output(path)
      @output = File.open(path, "w")
    end
    
    def write_output(content)
      @output.write(content.to_yaml())
      puts "writing output_file"
    end
    
    def create_replace()
      @replace = File.open(FILE_REPLACE, "w")
    end
    
    def create_processed()
      @processed = File.open(FILE_PROCESSED, "w")
    end
    
    def _delete
  
      case @mode
      when "search"
        File.delete(@items, @found)
        @items = nil
        @found = nil

      else
        File.delete(@items, @found, @replace, @processed)
        @items = nil
        @found = nil
        @replace = nil
        @processed = nil
        @output = nil
      end        
    end
    
    def close
      
      case @mode
      when "search"
        @items.close
        @found.close
        @output.close
        @output = nil


      else
        @items.close
        @found.close
        @replace.close
        @processed.close
        @output.close
      end
      
      _delete        
    end
    
  end
end