require "valvat_cache/version"
require "valvat"
require "json"

class Valvat::Lookup
  # Class methods
  class << self
    def cache
      @@cache ||= Hash.new
    end

    def cache=(cache_hash)
      @@cache = cache_hash.is_a?(Hash) ? cache_hash : Hash.new
    end

    def cache_path
      @@cache_path ||= nil
    end

    def cache_path=(path)
      if !path.nil?
        if File.file?(path)
          self.cache = JSON.parse(File.open(path, 'r') { |f| f.read }, symbolize_names: true)
          self.cache.each { |_k, v| v[:request_date] = Date.parse v[:request_date] }
        else
          self.cache = Hash.new.to_json
          File.open(path, 'w') { |f| f.write(cache) }
        end
      end

      @@cache_path = path
    end
  end

  private

  def response
    if self.class.cache[vat.raw.to_sym].nil? || (Date.today - self.class.cache[vat.raw.to_sym][:request_date]) > 7
      self.class.cache[vat.raw.to_sym] = request.perform(self.class.client)
      begin
        File.open(self.class.cache_path, 'w') { |f| f.write self.class.cache.to_json } if self.class.cache_path
      rescue Exception
      end
    end

    @response ||= self.class.cache[vat.raw.to_sym]
  end
end
