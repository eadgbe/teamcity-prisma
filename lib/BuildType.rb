module TeamcityPrisma
  
  class BuildType
    @@params = ["-t", "build_type"]
    $result = Array.new
    
    def find_string(site, string)
      @string = string
      #TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{seconds}", "-o", "#{operator}", "-m", "search"])
      TeamcityPrisma::Core.new(@@params + ["-S", "#{site}", "-s", "#{string}", "-o", "contains", "-m", "search"])
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
  end

end