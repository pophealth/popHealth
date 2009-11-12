module Funkytown
  module HashExtensions
    def keys_to_symbols
      out = {}
      each do |key, value|
        if key.kind_of? String
          out[key.to_sym] = value
        else
          out[key] = value
        end
      end
      out
    end
  end
end

class Hash
  include Funkytown::HashExtensions
end