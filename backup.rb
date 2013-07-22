# encoding: utf-8

$:.unshift('.')

require 'ftp_client'
require 'yaml'

rails_apps = {
  'app1' => '/www/app1/current/config/database.yml',
  'app2' => '/www/app1/current/config/database.yml'
}

rails_apps.each do |name, filename|
  config = YAML.load_file(filename)['production']

  `mysqldump -u #{config['username']} -p#{config['password']} #{config['database']} > #{name}-backup.sql`
  `bzip2 #{name}-backup.sql`
end

backup_files = rails_apps.map { |name, filename| "#{name}-backup.sql.bz2" }

FtpClient.create_backup(backup_files)

`rm #{backup_files.join(' ')}`
