This is script will backup your data to ftp server prodived by Hetzner.

## Usage

Create ftp.yml file and enter your ftp server credentials. Look at ftp.yml.example.

Write code that will create backup of your files, database etc., and use FtpClient.create_backup method to transfer these files to ftp server. Look at backup.rb file for some examples.

## Copyright

Copyright (c) 2013 Michał Młoźniak.