require 'sshkit/dsl'
require_relative 'chef_host'

module ChefRunner #ChefRemote
  class Solo

    def initialize(json)
      @json = json
      @chef_repo = json['chef-repo']
      @chef_repo_path = @chef_repo['path']
    end

    def run
      tar_chef_repo
      solo_run
      cleanup_tar
    end

    def solo_run

      servers = get_servers
      hosts = create_hosts servers
      environment = @json['environment']
      secret_path = @chef_repo['secret']
      on(hosts) { |host|

        Solo.upload_chef_repo(self)
        Solo.extract_chef_repo(self)
        Solo.upload_solo_file(self, environment)
        Solo.upload_node_file(self, host.server['chef']['run_list'])
        Solo.upload_chef_secret(self, secret_path)
        Solo.run_chef_solo(self)
      }
    end

    def get_servers
      @json['servers']
    end

    def create_hosts(servers)
      servers.collect { |server|
        ChefHost.new(server['host'], server, server['ssh'])
      }
    end

    def tar_chef_repo
      tar_path = File.join(Dir.pwd, 'chef-repo.tar.gz')
      puts system "tar -czf #{tar_path} -C #{@chef_repo_path} ."
    end

    def cleanup_tar
      system 'rm chef-repo.tar.gz'
    end

    def self.upload_chef_repo(backend)
      backend.upload!('chef-repo.tar.gz', '/tmp')
    end

    def self.extract_chef_repo(backend)
      backend.execute 'rm -rf /tmp/chef-repo'
      backend.execute 'mkdir /tmp/chef-repo'
      backend.execute 'tar -xzf /tmp/chef-repo.tar.gz -C /tmp/chef-repo'
    end

    def self.upload_solo_file(backend, environment)
      repo = '/tmp/chef-repo/'
      solo = <<-EOF
solo true
cookbook_path '#{repo}cookbooks'
role_path '#{repo}roles'
data_bag_path '#{repo}data_bags'
environment_path '#{repo}environments'
environment '#{environment}'
log_level :info
verbose_logging false
      EOF

      backend.upload! StringIO.new(solo), '/tmp/solo.rb'
    end

    def self.upload_node_file(backend, run_list)
      solo = {run_list: run_list}
      backend.upload! StringIO.new(solo.to_json), '/tmp/node.json'
    end

    def self.upload_chef_secret(backend, secret_file)
      backend.upload!(secret_file, '/tmp')
    end

    def self.run_chef_solo(backend)
      backend.execute 'sudo chef-solo -c /tmp/solo.rb -j /tmp/node.json'
    end
  end
end