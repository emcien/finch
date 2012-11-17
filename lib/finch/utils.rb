module Finch
  module Utils
    def self.keys_to_sym hashv
      Hash[ hashv.map{|k,v| [k.to_sym,v]} ]
    end
  end
end