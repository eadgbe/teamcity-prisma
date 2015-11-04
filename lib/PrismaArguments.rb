require 'optparse'


module TeamcityPrisma

  class PrismaArguments < Hash
    def initialize(args)
      super()
      self[:string] = ''
        
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: #$0 [options]"
        opts.on('-s', '--search-string [STRING]',
                'search [STRING]') do |string|
          self[:string] = string
        end
        
        opts.on('-m', '--mode [STRING]',
                'mode of use [ search | replace ]') do |string|
          self[:mode] = string
        end
        
        opts.on('-S', '--site [STRING]',
                'site [ dev | tc1 ]') do |string|
          self[:site] = string
        end
        
        opts.on('-r', '--resume',
                'resume in case the execution was stopped') do
          self[:resume] = 1
        end
        
        opts.on('-t', '--type [STRING]',
                'type of object [ vcs_root | build_type | project ]') do |string|
          self[:type] = string
        end

        opts.on('-o', '--operator-search [STRING]',
                'search operator [ minor_than | greater_than | equals | contains ]') do |string|
          self[:operator] = string
        end
        
        opts.on('-O', '--output-file [STRING]',
                'specify the output file path < FilePath >') do |string|
          self[:output] = string.gsub("\\", "/")
            puts self[:output]
        end
        
        opts.on('-c', '--config [STRING]',
                'specify the input config file path < FilePath >') do |string|
          self[:config] = string.gsub("\\", "/")
        end
        
        opts.on('-z', '--step-type [STRING]',
                'step type when using "--type build_type <step type>", if it is not specified the search will include all steps') do |string|
          self[:step_type] = string
        end
        
        opts.on_tail('-h', '--help', 'display this help and exit') do
          puts opts
          exit
        end
      end
      
      opts.parse!(args)
      
      #check for required arguments
      begin
        raise OptionParser::MissingArgument if self[:mode]=='' or self[:mode].nil?
        raise OptionParser::MissingArgument if self[:operator]=='' or self[:operator].nil?
        raise OptionParser::MissingArgument if self[:output]=='' or self[:output].nil?   
        raise OptionParser::MissingArgument if self[:config]=='' or self[:config].nil?   
        raise OptionParser::MissingArgument if self[:string]=='' or self[:string].nil?
        raise OptionParser::MissingArgument if self[:site]=='' or self[:site].nil?
        raise OptionParser::MissingArgument if self[:type]=='' or self[:type].nil?   
           
          
      rescue OptionParser::MissingArgument 
        abort( "#{$!} Missing mandatory argument, please check your syntax. Performing task with options: #{self.inspect}")
      end
      
      #check for arguments syntax
      begin
        raise OptionParser::InvalidArgument unless /#{self[:mode]}/.match('search|replace|modify')
        raise OptionParser::InvalidArgument unless /#{self[:site]}/.match('dev|tc1|tc2|tc3')
        raise OptionParser::InvalidArgument unless /#{self[:operator]}/.match('minor_than|greater_than|equal|contains')
        raise OptionParser::InvalidArgument unless /#{self[:type]}/.match('vcs_root|build_type|project')
      
      rescue OptionParser::InvalidArgument
        abort( "#{$!} Incorrect argument value, please check your syntax. Performing task with options: #{self.pretty_inspect}")
      end
      
    end
  end
  
end