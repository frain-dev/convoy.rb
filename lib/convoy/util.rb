module Convoy
  module Util
    # Constant time string comparison to prevent timing attacks
    # Code borrowed from ActiveSupport
    def self.secure_compare(str_a, str_b)
      return false unless str_a.bytesize == str_b.bytesize

      l = str_a.unpack "C#{str_a.bytesize}"

      res = 0
      str_b.each_byte { |byte| res |= byte ^ l.shift }
      res.zero?
    end
  end
end
