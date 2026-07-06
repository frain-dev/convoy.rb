require "test_helper"

# Vectors generated with the server's signature scheme (pkg/signature):
# simple = HMAC(secret, payload), advanced = HMAC(secret, "{t},{payload}").
# The advanced timestamp is far in the future so tolerance never expires.
class WebhookTest < Minitest::Test
  SIMPLE_PAYLOAD = '{"mode":"sig-simple","n":42}'.freeze
  SIMPLE_SECRET = "sig-simple-secret".freeze
  SIMPLE_HEX = "eaa91c1f2dfc842e8873a895d75dfd2d5757c622f0b6d6022d6d48864d41d2fc".freeze
  SIMPLE_B64 = "6qkcHy38hC6Ic6iV1139LVdXxiLwttYCLW1Ihk1B0vw=".freeze

  ADV_PAYLOAD = '{"mode":"sig-adv","n":42}'.freeze
  ADV_SECRET = "sig-adv-secret".freeze
  ADV_HEX_HEADER = "t=2048976161,v1=a89599858951cff83b61ca2f50b8138af92e09388be7723c28a380397c1a8391".freeze
  ADV_B64_HEADER = "t=2048976161,v1=qJWZhYlRz/g7YcovULgTivkuCTiL53I8KKOAOXwag5E=".freeze

  def test_verify_simple_hex_signature
    webhook = Convoy::Webhook.new(SIMPLE_SECRET)
    assert_equal true, webhook.verify(SIMPLE_PAYLOAD, SIMPLE_HEX)
  end

  def test_verify_simple_base64_signature
    webhook = Convoy::Webhook.new(SIMPLE_SECRET, encoding: "base64")
    assert_equal true, webhook.verify(SIMPLE_PAYLOAD, SIMPLE_B64)
  end

  def test_reject_tampered_simple_payload
    webhook = Convoy::Webhook.new(SIMPLE_SECRET)
    assert_equal false, webhook.verify(SIMPLE_PAYLOAD.sub("42", "43"), SIMPLE_HEX)
  end

  def test_reject_wrong_simple_secret
    webhook = Convoy::Webhook.new("wrong-secret")
    assert_equal false, webhook.verify(SIMPLE_PAYLOAD, SIMPLE_HEX)
  end

  def test_verify_advanced_hex_signature
    webhook = Convoy::Webhook.new(ADV_SECRET)
    assert_equal true, webhook.verify(ADV_PAYLOAD, ADV_HEX_HEADER)
  end

  def test_verify_advanced_base64_signature
    webhook = Convoy::Webhook.new(ADV_SECRET, encoding: "base64")
    assert_equal true, webhook.verify(ADV_PAYLOAD, ADV_B64_HEADER)
  end

  def test_reject_tampered_advanced_payload
    webhook = Convoy::Webhook.new(ADV_SECRET)
    assert_raises(Convoy::SignatureVerificationError) do
      webhook.verify(ADV_PAYLOAD.sub("42", "43"), ADV_HEX_HEADER)
    end
  end

  def test_reject_expired_advanced_timestamp
    webhook = Convoy::Webhook.new(ADV_SECRET)
    expired = "t=1000000000,v1=#{ADV_HEX_HEADER.split('v1=').last}"
    assert_raises(Convoy::SignatureVerificationError) do
      webhook.verify(ADV_PAYLOAD, expired)
    end
  end

  def test_reject_advanced_header_missing_timestamp
    webhook = Convoy::Webhook.new(ADV_SECRET)
    assert_raises(Convoy::SignatureVerificationError) do
      webhook.verify(ADV_PAYLOAD, "v1=deadbeef,v2=cafe")
    end
  end

  def test_reject_advanced_header_malformed_timestamp
    webhook = Convoy::Webhook.new(ADV_SECRET)
    assert_raises(Convoy::SignatureVerificationError) do
      webhook.verify(ADV_PAYLOAD, "t=abc,v1=deadbeef")
    end
  end
end
