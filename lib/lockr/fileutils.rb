module FileUtils
  
  # rotate the provided file with a maximum of 'limit' backups
  # renamed filed will be named file_0, file_1, ...
  def rotate_file( file, limit)
    return unless File.exists?(file)
    
    # move old files first
    max_files = limit - 1 
    max_files.downto( 0) { |i|
      
      if i == 0
        File.rename( file, "#{file}_#{i}")
      else
        j = i - 1
        if File.exists?("#{file}_#{j}")
          File.rename( "#{file}_#{j}", "#{file}_#{i}")  
        end
      end
    }
  end  
  
  # store an object as yaml to file
  def store_obj_yaml( file, object)
    File.open( file, 'w') do |f|
      f.write( object.to_yaml)
    end
  end
  
  # load an yaml object from file
  def load_obj_yaml( file)
    object = nil
    
    unless File.exist?( file)
      raise ArgumentError, "file '#{file} does not exist"
    end
    
    File.open( file, 'r') do |f|
      object = YAML::load(f)
    end
    
    object
  end
end