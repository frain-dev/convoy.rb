require "test_helper"
require "json"

# signature-vectors.json is generated from the server signing code
# (convoy/pkg/signature) and vendored here so this SDK verifies against the same
# canonical set as every other Convoy SDK. Regenerate upstream with
# CONVOY_WRITE_VECTORS=1 go test ./pkg/signature -run TestGenerateSignatureVectors
class SharedVectorsTest < Minitest::Test
  VECTORS_PATH = File.expand_path("signature-vectors.json", __dir__)
  VECTORS = JSON.parse(File.read(VECTORS_PATH)).freeze

  VECTORS.each do |vec|
    define_method("test_#{vec["name"]}") do
      webhook = Convoy::Webhook.new(
        vec["secret"],
        encoding: vec["encoding"],
        tolerance: vec["tolerance"],
        hash: vec["hash"]
      )

      result =
        begin
          webhook.verify(vec["payload"], vec["header"])
        rescue Convoy::SignatureVerificationError
          false
        end

      if vec["valid"]
        assert_equal true, result, vec["name"]
      else
        # Fail closed: an invalid vector must be falsy, never a truthy value.
        refute result, vec["name"]
      end
    end
  end
end
