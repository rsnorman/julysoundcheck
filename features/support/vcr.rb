require 'webmock'
require 'vcr'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.config do |c|
  c.cassette_library_dir = 'features/fixtures/vcr_cassettes'
  c.ignore_localhost = true
  c.hook_into :webmock
  c.default_cassette_options = {
    :match_requests_on => [:method, :host, :path]
  }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
