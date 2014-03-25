require 'sshkit/dsl'
require_relative 'chef_host'

module ChefRunner
  class Bootstrap

    def initialize(json)
      @json = json
    end

    def run
      servers = get_servers
      hosts = create_hosts servers
      bootstrap_hosts hosts
    end

    private

    def get_servers
      @json['servers'].select { |server| server['chef']['bootstrap'] }
    end

    def create_hosts(servers)
      servers.collect { |server|
        ChefHost.new(server['host'], server, server['ssh'])
      }
    end

    def bootstrap_hosts(hosts)
      on(hosts) {
        execute :curl, '-L https://www.opscode.com/chef/install.sh | sudo bash'
      }
    end

  end
end