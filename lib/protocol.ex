defmodule Kafka.Protocol do
  @produce_request   0
  @fetch_request     1
  @offset_request    2
  @metadata_request  3

  @api_version  0

  defp api_key(:produce) do
    @produce_request
  end

  defp api_key(:fetch) do
    @fetch_request
  end

  defp api_key(:offset) do
    @offset_request
  end

  defp api_key(:metadata) do
    @metadata_request
  end

  def create_request(type, correlation_id, client_id) do
    << api_key(type) :: 16, @api_version :: 16, correlation_id :: 32,
       byte_size(client_id) :: 16, client_id :: binary >>
  end

  @error_map %{
     0 => :no_error,
     1 => :offset_out_of_range,
     2 => :invalid_message,
     3 => :unknown_topic_or_partition,
     4 => :invalid_message_size,
     5 => :leader_not_available,
     6 => :not_leader_for_partition,
     7 => :request_timed_out,
     8 => :broker_not_available,
     9 => :replica_not_available,
    10 => :message_size_too_large,
    11 => :stale_controller_epoch,
    12 => :offset_metadata_too_large,
    14 => :offset_loads_in_progress,
    15 => :consumer_coordinator_not_available,
    16 => :not_coordinator_for_consumer
  }

  def error(err_no) do
    case err_no do
      -1 -> :unknown_error
      _  -> @error_map[err_no] || err_no
    end
  end
end
