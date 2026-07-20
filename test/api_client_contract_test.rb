require "test_helper"
require "webmock/minitest"
require "convoy_api"

# Offline route-contract test: proves the generated client sends the verb,
# path, auth header, and JSON body the Convoy server expects, and that
# arbitrary event data payloads round-trip without dropping keys.
class ApiClientContractTest < Minitest::Test
  def setup
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.reset!
  end

  def test_create_endpoint_event_sends_expected_request
    captured = nil
    stub_request(:post, "https://us.getconvoy.cloud/api/v1/projects/proj-1/events")
      .to_return(lambda { |request|
        captured = request
        {
          status: 201,
          headers: { "Content-Type" => "application/json" },
          body: '{"status":true,"message":"ok","data":null}'
        }
      })

    config = ConvoyApi::Configuration.new do |c|
      c.host = "us.getconvoy.cloud"
      c.base_path = "/api"
      c.api_key["Authorization"] = "test-key"
      c.api_key_prefix["Authorization"] = "Bearer"
    end
    client = ConvoyApi::ApiClient.new(config)
    # Pin the API version the client was generated from, so servers configured
    # to an older CONVOY_API_VERSION don't down-convert responses into shapes
    # these models no longer match.
    client.default_headers["X-Convoy-Version"] = "2025-11-24"

    event = ConvoyApi::ModelsCreateEvent.new(
      endpoint_id: "ep-1",
      event_type: "invoice.paid",
      data: { "amount" => 100, "currency" => "USD",
              "nested" => { "customer" => "cus_123" } }
    )
    ConvoyApi::EventsApi.new(client).create_endpoint_event("proj-1", event)

    refute_nil captured
    assert_equal "Bearer test-key", captured.headers["Authorization"]
    assert_equal "2025-11-24", captured.headers["X-Convoy-Version"]
    assert_includes captured.headers["Content-Type"], "application/json"

    sent = JSON.parse(captured.body)
    assert_equal "ep-1", sent["endpoint_id"]
    assert_equal "invoice.paid", sent["event_type"]
    assert_equal 100, sent.dig("data", "amount")
    assert_equal "USD", sent.dig("data", "currency")
    assert_equal "cus_123", sent.dig("data", "nested", "customer")
  end

  # Inbound deserialization must keep every key of arbitrary event data.
  # This replicates ApiClient#deserialize exactly (JSON.parse with
  # symbolize_names: true, then build_from_hash): upstream OpenAPI Generator
  # behavior re-stringifies only the top level of Hash<String, Object>
  # fields, so NESTED keys arrive as symbols. Locked in here so a generator
  # bump that changes the contract fails loudly. Documented in the README.
  def test_event_data_inbound_keeps_all_keys
    raw = '{"uid":"evt-1","event_type":"invoice.paid",' \
          '"data":{"amount":100,"nested":{"customer":"cus_123"}}}'
    parsed = JSON.parse("[#{raw}]", symbolize_names: true)[0]
    ev = ConvoyApi::DatastoreEvent.build_from_hash(parsed)

    assert_equal 100, ev.data["amount"]
    assert_equal({ customer: "cus_123" }, ev.data["nested"])
  end
end
