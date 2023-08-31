# ENV['OPENC3_API_PASSWORD'] = 'password'
ENV['OPENC3_API_USER'] = 'admin'
ENV['OPENC3_API_PASSWORD'] = 'admin'
$api_server.instance_variable_get(:@json_drb).instance_variable_set(:@authentication, $api_server.generate_auth())

def install_plugin(gem_name:, variables:, plugin_txt_lines: nil, scope: $openc3_scope)
  endpoint = "/openc3-api/plugins/install/#{gem_name}"
  OpenC3::Logger.info "Installing plugin #{gem_name}"
  plugin_hash = {
    "name": gem_name,
    "variables": variables}
  plugin_hash["plugin_txt_lines"] = plugin_txt_lines if plugin_txt_lines
  response = $api_server.request('post', endpoint, data: { plugin_hash: plugin_hash.to_json }, json: true, scope: scope)
  if response.nil? || response.code != 200
    raise "Failed to install plugin #{gem_name} with code #{response.code}"
  end
end

def install_loadsim(target_name, gem_version, scope: $openc3_scope)
  gem_name = "openc3-load-sim-#{gem_version}.gem"
  variables = {
    "sim_target_name": target_name,
    "num_tlm_packets": "10",
    "num_tlm_items_per_packet": "20",
    "num_tlm_derived_items_per_packet": "5",
    "num_tlm_bytes_per_packet": "80",
    "num_each_tlm_packet_per_sec": "1",
    "num_cmd_packets": "10",
    "num_cmd_items_per_packet": "20",
    "num_cmd_derived_items_per_packet": "5",
    "num_cmd_bytes_per_packet": "80"}
  plugin_txt_lines = [
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
    "TARGET LOADSIM #{target_name}",
    "  TLM_BUFFER_DEPTH 200",
    "",
    "INTERFACE INT_#{target_name} simulated_target_interface.rb sim_loadsim.rb",
    "  MAP_TARGET #{target_name}"]

  install_plugin(gem_name: gem_name, variables: variables, plugin_txt_lines: plugin_txt_lines, scope: scope)
end

x = 1
# (1..10).each do |x|
  install_loadsim("LOADSIM#{x}", "1.0.0")
  wait 5
# end