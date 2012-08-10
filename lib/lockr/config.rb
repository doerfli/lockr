class Configuration
  CONFIG_FILE = '.lockr'
  attr_reader :config
  
  def initialize()
    @config = nil
    
    filename = File.expand_path("~/#{CONFIG_FILE}")
    if File.exists?( filename)
      File.open( filename, 'r') do |f|
        @config = YAML::load(f)
      end
    end
  end
end