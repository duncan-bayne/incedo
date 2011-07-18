########################################################
# Copyright (C) 2009 - 2011, Duncan Bayne.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 3 of the GNU Lesser General Public License 
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# The GNU Lesser General Public License can be viewed at
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# To find out more about incedo, visit
# http://code.google.com/p/incedo
########################################################

require 'rss'
require 'yaml'

# ruby-debug Gem doesn't install on iPhone
#require 'ruby-debug'

class FeedMonitor

  attr_accessor :feeds
  attr_accessor :patterns
  attr_accessor :alerts
  attr_accessor :action

  def set_last_alert_time(time)
    File.open("last_alert_time.txt", "w") do |f|
      f.puts "#{time}"
    end
  end

  def get_last_alert_time
    last_alert_time = Time.parse("2000-12-31")
    if File.exists?("last_alert_time.txt")
      File.open("last_alert_time.txt", "r") do |f|
        last_alert_time = Time.parse(f.gets)
      end
    end
    return last_alert_time
  end

  def initialize(config_filename, feed_reader)
    @feed_reader = feed_reader

    puts "incedo: loading config file #{config_filename}"
    @configuration = YAML::load_file(config_filename)

    puts "incedo: found #{@configuration['feeds'].length} feeds"
    @feeds = []
    for feed in @configuration['feeds'].values
      feeds << feed
    end

    puts "incedo: found #{@configuration['patterns'].length} patterns"
    @patterns = []
    for pattern in @configuration['patterns'].values
      patterns << pattern
    end

    puts "incdeo: found action #{@configuration['action']}"
    @action = @configuration['action']
    
    puts "incedo: last alert time #{get_last_alert_time()}"
    
    @alerts = []
  end

  def perform_action
    if (@action != nil)
      system(@action)
    else
      puts "incedo: ALERT!"
    end
  end

  def refresh
    @alerts = []
    result = false
    begin
      puts "incedo: checking #{feeds.length} feed#{feeds.length > 1 ? 's' : ''}"
      for feed in feeds do
        rss = @feed_reader.get_rss(feed)
        puts "incedo: read #{rss.items.length} from #{feed}"		  
        for item in rss.items
          for pattern in patterns do
            if item.description =~ /#{pattern}/i and item.date > get_last_alert_time
              @alerts << item
              puts "incedo: new item with title '#{item.title}'" 
              set_last_alert_time(item.date)
            end
          end  
        end
      end

      if @alerts.length > 0
        puts "incedo: found new alerts, so performing action '#{@action}'"
        perform_action()
      end

      result = true
    rescue Exception => e
      puts "incedo: an exception was raised: #{e}"
      result = false
    end

    return result
  end

end
