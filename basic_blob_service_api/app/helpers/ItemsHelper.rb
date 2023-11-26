module ItemsHelper
  def self.clean_empty_folders(base_path)
    Dir.glob(File.join(base_path, '**', '*')).select { |f| File.directory?(f) && Dir.empty?(f) }.each do |empty_folder|
      Dir.rmdir(empty_folder)
    end
  end
end
