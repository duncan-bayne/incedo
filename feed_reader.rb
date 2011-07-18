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
require 'open-uri'

class FeedReader

  def get_rss(uri)
    puts "incedo: reading #{uri}"
    rss_content = nil
    open(uri) do |f|
      rss_content = f.read
    end
    return RSS::Parser.parse(rss_content, false)
  end

end
