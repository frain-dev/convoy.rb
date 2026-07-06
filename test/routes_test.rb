require "test_helper"
require "json"

class RoutesTest < Minitest::Test
  BASE = "https://us.getconvoy.cloud/api/v1/projects/test-project-id".freeze
  OK_BODY = { status: true, message: "ok", data: nil }.to_json.freeze

  def setup
    Convoy.base_uri = "https://us.getconvoy.cloud/api"
    Convoy.api_key = "test-api-key"
    Convoy.project_id = "test-project-id"
  end

  def test_batch_retry_posts_empty_body_with_query_filters
    stub = stub_request(:post, "#{BASE}/eventdeliveries/batchretry")
           .with(query: { "status" => "Failure" }, body: "{}")
           .to_return(status: 200, body: OK_BODY)

    Convoy::EventDelivery.new(params: { status: "Failure" }).batch_retry
    assert_requested(stub)
  end

  def test_force_retry_posts_ids_body
    stub = stub_request(:post, "#{BASE}/eventdeliveries/forceresend")
           .with(body: { ids: ["ed-1"] }.to_json)
           .to_return(status: 200, body: OK_BODY)

    Convoy::EventDelivery.new(data: { ids: ["ed-1"] }).force_retry
    assert_requested(stub)
  end

  def test_endpoint_pause_uses_put
    stub = stub_request(:put, "#{BASE}/endpoints/ep-1/pause")
           .to_return(status: 202, body: OK_BODY)

    Convoy::Endpoint.new("ep-1").pause
    assert_requested(stub)
  end

  def test_endpoint_expire_secret_uses_put
    stub = stub_request(:put, "#{BASE}/endpoints/ep-1/expire_secret")
           .with(body: { expiration: 24 }.to_json)
           .to_return(status: 200, body: OK_BODY)

    Convoy::Endpoint.new("ep-1", data: { expiration: 24 }).expire_secret
    assert_requested(stub)
  end

  def test_event_broadcast_posts_to_broadcast
    stub = stub_request(:post, "#{BASE}/events/broadcast")
           .to_return(status: 201, body: OK_BODY)

    Convoy::Event.new(data: { event_type: "x", data: {} }).broadcast
    assert_requested(stub)
  end

  def test_collection_routes_ignore_instance_id
    broadcast_stub = stub_request(:post, "#{BASE}/events/broadcast")
                     .to_return(status: 201, body: OK_BODY)
    batch_stub = stub_request(:post, "#{BASE}/eventdeliveries/batchretry")
                 .to_return(status: 200, body: OK_BODY)
    force_stub = stub_request(:post, "#{BASE}/eventdeliveries/forceresend")
                 .to_return(status: 200, body: OK_BODY)

    Convoy::Event.new("ev-1", data: { event_type: "x", data: {} }).broadcast
    Convoy::EventDelivery.new(nil, "ed-1").batch_retry
    Convoy::EventDelivery.new(nil, "ed-1", data: { ids: ["ed-1"] }).force_retry

    assert_requested(broadcast_stub)
    assert_requested(batch_stub)
    assert_requested(force_stub)
  end

  def test_replay_requires_event_id
    assert_raises(ArgumentError) { Convoy::Event.new.replay }
  end

  def test_retry_requires_delivery_id
    assert_raises(ArgumentError) { Convoy::EventDelivery.new.retry }
  end

  def test_event_create_sets_auth_and_version_headers
    stub = stub_request(:post, "#{BASE}/events")
           .with(headers: {
                   "Authorization" => "Bearer test-api-key",
                   "X-Convoy-Version" => "2025-11-24",
                 })
           .to_return(status: 201, body: OK_BODY)

    Convoy::Event.new(data: { endpoint_id: "ep-1", event_type: "x", data: {} }).save
    assert_requested(stub)
  end
end
