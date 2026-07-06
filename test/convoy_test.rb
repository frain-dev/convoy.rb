require "test_helper"

class ConvoyTest < Minitest::Test
  def setup
    Convoy.base_uri = "https://us.getconvoy.cloud/api"
    Convoy.api_key = "test-api-key"
    Convoy.project_id = "test-project-id"
  end

  def test_that_it_has_a_version_number
    refute_nil ::Convoy::VERSION
  end

  def test_endpoint_resource_uri_is_project_scoped
    endpoint = Convoy::Endpoint.new
    assert_equal "https://us.getconvoy.cloud/api/v1/projects/test-project-id/endpoints", endpoint.resource_uri
  end

  def test_event_resource_uri_is_project_scoped
    event = Convoy::Event.new("event-id")
    assert_equal "https://us.getconvoy.cloud/api/v1/projects/test-project-id/events/event-id", event.resource_uri
  end

  def test_missing_base_uri_raises
    Convoy.base_uri = nil
    assert_raises(ArgumentError) { Convoy::Endpoint.new.resource_uri }
  end

  def test_missing_project_id_raises
    Convoy.project_id = nil
    assert_raises(ArgumentError) { Convoy::Endpoint.new.resource_uri }
  end
end
