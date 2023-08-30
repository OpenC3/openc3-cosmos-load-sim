ENV['OPENC3_API_PASSWORD'] = 'password'
$api_server.instance_variable_get(:@json_drb).instance_variable_set(:@authentication, $api_server.generate_auth())

def install_plugin(gem_name:, variables:, plugin_txt_lines: nil, scope: $openc3_scope)
  endpoint = "/openc3-api/plugins/install/#{gem_name}"
  OpenC3::Logger.info "Installing plugin #{gem_name}"
  plugin_hash = {
    "name": gem_name,
    "variables": variables}
  plugin_hash["plugin_txt_lines"] = plugin_txt_lines if plugin_txt_lines
  response = $api_server.request('post', endpoint, data: { "plugin_hash" => plugin_hash.to_json }, scope: scope)
  if response.nil? || response.code != 200
    raise "Failed to install plugin #{gem_name}"
  end
end

def install_loadsim(target_name, gem_version, scope: $openc3_scope)
  gem_name = "openc3-load-sim-#{gem_version}.gem"
  variables = {
    "sim_target_name": target_name,
    "num_tlm_packets": "100",
    "num_tlm_items_per_packet": "100",
    "num_tlm_derived_items_per_packet": "5",
    "num_tlm_bytes_per_packet": "200",
    "num_each_tlm_packet_per_sec": "1",
    "num_cmd_packets": "100",
    "num_cmd_items_per_packet": "20",
    "num_cmd_derived_items_per_packet": "5",
    "num_cmd_bytes_per_packet": "100"}
  plugin_txt_lines = [
    "# Note: This plugin includes 4 targets in one plugin to make it easy to install",
    "# the demo with one plugin.  Generally it is better to only have one",
    "# target per plugin",
    "",
    "VARIABLE sim_target_name LOADSIM",
    "VARIABLE num_tlm_packets 10",
    "VARIABLE num_tlm_items_per_packet 1000",
    "VARIABLE num_tlm_derived_items_per_packet 5",
    "VARIABLE num_tlm_bytes_per_packet 1000",
    "VARIABLE num_each_tlm_packet_per_sec 10",
    "VARIABLE num_cmd_packets 10",
    "VARIABLE num_cmd_items_per_packet 20",
    "VARIABLE num_cmd_derived_items_per_packet 5",
    "VARIABLE num_cmd_bytes_per_packet 100",
    "",
    "TARGET LOADSIM <%= sim_target_name %>",
    "  TLM_BUFFER_DEPTH 200",
    "",
    "INTERFACE INT_<%= sim_target_name %> simulated_target_interface.rb sim_loadsim.rb",
    "  MAP_TARGET <%= sim_target_name %>"]

  install_plugin(gem_name: gem_name, variables: variables, plugin_txt_lines: plugin_txt_lines, scope: scope)
end

install_loadsim("LOADSIM3", "1.0.0")