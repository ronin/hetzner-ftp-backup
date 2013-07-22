# encoding: utf-8

require 'yaml'
require 'net/ftp'

class FtpClient
  class << self
    def list
      open_connection do |client|
        puts client.list('*')
      end
    end

    def create_backup(filenames)
      backup_directory_name = Time.now.strftime('%Y%m%d%H%M%S')

      open_connection do |client|
        client.mkdir(backup_directory_name)
        client.chdir(backup_directory_name)

        filenames.each do |filename|
          client.put(filename)
        end
      end
    rescue Net::FTPPermError
      puts 'Error: Cannot create backup'
    end

    private
    def open_connection
      config = load_configuration

      client = Net::FTP.new(config['host'])
      client.login(config['user'], config['pass'])

      begin
        client.chdir('backups')
      rescue Net::FTPPermError
        client.mkdir('backups')
        client.chdir('backups')
      end

      yield(client)

    rescue Net::FTPPermError
      puts 'Error: Authentication failed'
    ensure
      client.close
    end

    def load_configuration
      YAML.load_file('ftp.yml')
    rescue Errno::ENOENT
      puts 'Error: Configuration file not found'
      exit
    end
  end
end
