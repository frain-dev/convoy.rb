module Convoy

  class SignatureVerificationError < StandardError
  end

  DEFAULT_TOLERANCE = 300
  DEFAULT_ENCODING = "hex"
  DEFAULT_HASH = "SHA256"

  # webhook := Webhook.new(secret)
  #
  # With Tolerance
  # webhook := Webhook.new(secret, tolerance: 500)
  #
  # with Encoding
  # webhook = Webhook.new(secret, encoding: "base64")
  #
  # With Encoding and Tolerance
  # webhook = Webhook.new(secret, encoding: "base64", tolerance: 900)
  #
  # Verify request
  # webhook.verify(payload, headers)

  class Webhook
    def initialize(secret, encoding: DEFAULT_ENCODING, tolerance: DEFAULT_TOLERANCE, hash: DEFAULT_HASH)
      @secret = secret
      @encoding = encoding
      @tolerance = tolerance
      @hash = hash
    end

    def verify(payload, sig_header)
      # 1. Detect Signature Type.
      is_advanced = (sig_header.split(",")).length > 1
      
      if is_advanced
        return verify_advanced_signature(payload, sig_header)
      end

      verify_simple_signature(payload, sig_header)
    end

    private 

    def verify_simple_signature(payload, sig_header)
      return Util.secure_compare(compute_signature(payload), sig_header)
    end

    def verify_advanced_signature(payload, sig_header)
      timestamp_header, signatures = get_timestamp_and_signatures(sig_header)
      payload = "#{Integer(timestamp_header)},#{payload}"

      verify_timestamp(timestamp_header)

      unless signatures.any? { |s| Util.secure_compare(compute_signature(payload), s) }
        raise SignatureVerificationError.new,
        "No signatures found matching the expected signature for payload"
      end

      return true
    end

    def verify_timestamp(timestamp_header)
      begin
        now = Integer(Time.now)
        timestamp = Integer(timestamp_header)
      rescue
        raise SignatureVerificationError, "Could parse timestamp header"
      end

      if timestamp < (now - @tolerance)
        raise SignatureVerificationError, "Message timestamp too old"
      end
    end

    # return encoded string
    def compute_signature(payload)
      case @encoding
      when "hex"
        val = OpenSSL::HMAC.hexdigest(@hash, @secret, payload)
        return val
      when "base64"
        hmac = OpenSSL::HMAC.digest(@hash, @secret, payload)
        return Base64.strict_encode64(hmac)
      end
    end

    def get_timestamp_and_signatures(sig_header)
      list_items = sig_header.split(/,\s*/).map { |i| i.split("=", 2) }
      timestamp = Integer(list_items.select { |i| i[0] == "t" }[0][1])
      signatures = list_items[1..].map { |i| i[1] }
      [Time.at(timestamp), signatures]
    end
  end
end
