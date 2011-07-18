#!/usr/bin/ruby

########################################################
# Copyright (C) 2009, Duncan Bayne.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
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

require 'feed_monitor'
require 'feed_reader'

while true
  begin
    feed_monitor = FeedMonitor.new("config.yml", FeedReader.new)

    if (feed_monitor.action == nil)
      puts "incedo: there is no action specified in config.yml"
      puts "incedo: INCEDO IS NO LONGER RUNNING!"
      Process.exit!  # but see http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/170422
    end

    while true
      if (!feed_monitor.refresh)
        raise "refresh failed"
      end

      puts "incedo: sleeping for 600 seconds"
      sleep 600
    end
  rescue Exception => e
    puts "incedo: an exception has been raised: #{e}"
    feed_monitor.perform_action()
  end
end

