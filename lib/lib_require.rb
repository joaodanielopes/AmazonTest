require_files = Dir[File.dirname(__FILE__) + '/*.rb']
begin
  retry_files, retry_exception = [], Exception
  require_files.each do |file|
    begin
      require file
    rescue NameError => e
      retry_files << file
      retry_exception = e
    end
  end
  require_files.size == retry_files.size ? raise(retry_exception) : require_files = retry_files
end until require_files.empty?