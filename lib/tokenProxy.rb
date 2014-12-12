require "yaml"
require "fileutils"
module DropboxShell
  class TokenProxy
    PATH = "#{File.expand_path(".")}/data/access_token"
    CONFIG_PATH = "#{File.expand_path(".")}/data/config.yml"

    def self.fetch
      execute_handshake unless token_exists?
      cached_token
    end

    private

    def self.token_exists?
      !Dir.glob(PATH).empty?
    end

    def self.save(token)
      File.open(PATH, 'w') do |file|
        file.puts token
      end
    end

    def self.cached_token
      File.read(PATH).to_s.strip
    end

    def self.reset
      FileUtils.rm(PATH)
    end

    def self.execute_handshake
      config = YAML.load_file(CONFIG_PATH)
      flow = DropboxOAuth2FlowNoRedirect.new(config["key"], config["secret"])
      authorize_url = flow.start()
      puts '1. Go to: ' + authorize_url
      puts '2. Click "Allow" (you might have to log in first)'
      puts '3. Copy the authorization code'
      print 'Enter the authorization code here: '
      auth_code = gets.strip
      access_token, user_id = flow.finish(auth_code)
      save(access_token)
      puts "Handshake Complete!!!"
    end
  end
end
