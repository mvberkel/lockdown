require File.join(File.dirname(__FILE__), "lockdown", "classy-inheritance")
require File.join(File.dirname(__FILE__), "lockdown", "helper")

module Lockdown
  # :stopdoc:
  VERSION = '0.7.0'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:
  
  class << self
    include Lockdown::Helper

    # Returns the version string for the library.
    #
    def version
      VERSION
    end
 
    # Mixin Lockdown code to the appropriate Controller and ORM
    #
    def mixin
      if mixin_resource?("frameworks")
        unless mixin_resource?("orms")
          raise NotImplementedError, "ORM unknown to Lockdown!"
        end
      else
        puts "Environment unknown to Lockdown! Assuming I was required for a rake task or similar utility."
      end
    end # mixin

    private

    def mixin_resource?(str)
      wildcard_path = File.join( File.dirname(__FILE__), 'lockdown', str , '*.rb' ) 
      Dir[wildcard_path].each do |f|
        require f
        module_name = File.basename(f).split(".")[0]
        module_class = eval("Lockdown::#{str.capitalize}::#{Lockdown.camelize(module_name)}")
        if module_class.use_me?
          include module_class
          puts "==============================> using: #{module_class}"
          return true
        end
      end
      false
    end # mixin_resource?
  end # class block
end # Lockdown


require File.join(File.dirname(__FILE__), "lockdown", "system")
require File.join(File.dirname(__FILE__), "lockdown", "controller")
require File.join(File.dirname(__FILE__), "lockdown", "session")

Lockdown.mixin
