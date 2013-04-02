#!/usr/bin/env ruby
# coding: UTF-8

# job.rb
# 
# base class for cron jobs
# 
# created on : 2012.09.03
# last update: 2013.04.02
# 
# by meinside@gmail.com

require "yaml"

# using: https://github.com/meinside/myrubyscripts
require_relative "../../ruby/libs/my_gmail"

class Job

  CONFIG_FILEPATH = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "configs", "configs.yml"))

# config file(.yml) format
=begin
---
mail_notification:
  gmail_sender:
    username: _gmail_username_
    passwd: _gmail_passwd_
  email_recipient:
    email: _recipient_email_address_
=end

  @configs = nil

  def initialize
    @configs = read_configs

    if block_given?
      yield self
    end
  end

  def read_configs
    if File.exists? CONFIG_FILEPATH
      File.open(CONFIG_FILEPATH, "r"){|file|
        begin
          return YAML.load(file)
        rescue
          puts "* error parsing config file: #{CONFIG_FILEPATH}"
        end
      }
    else
      puts "* config file not found: #{CONFIG_FILEPATH}"
    end
    return nil
  end

  def send_gmail(title, html_content)
    configs = @configs["mail_notification"]
    MyGmail.send({
      username: configs["gmail_sender"]["username"],
      passwd: configs["gmail_sender"]["passwd"],
      recipient: configs["email_recipient"]["email"],
      title: title,
      html_content: html_content,
    })
  end

end

