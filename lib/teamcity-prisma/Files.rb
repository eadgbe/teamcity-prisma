module TeamcityPrisma
  class Files
    def initialize(mode)
      case mode
      when "search"
        create_items()
        create_found()
        
      when "replace"
        create_replace()
        create_processed()
      else
      end      
    end
    
    def create_items()
      @items = File.open(FILE_ITEMS, "w")
      puts "creating items_file"
    end
    
    def write_items(content)
      @items.write(content.to_yaml())
      puts "writting items_file"
    end
    
    def create_found()
      @found = File.open(FILE_FOUND, "w")
    end
    
    def write_found(content)
      @found.write(content.to_yaml())
      puts "writting found_file"
    end
    
    def create_replace()
      @replace = File.open(FILE_REPLACE, "w")
    end
    
    def create_processed()
      @processed = File.open(FILE_PROCESSED, "w")
    end
    
    def close
      @items.close
      @found.close
      #@replace.close
      #@processed.close      
    end
    
  end
end