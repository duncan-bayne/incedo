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

require 'feed_monitor'
require 'test/unit'
require 'test/unit/ui/console/testrunner'

class FeedMonitorTests < Test::Unit::TestCase
  
  def setup
    super

    File.delete("last_alert_time.txt") if File.exists?("last_alert_time.txt")
    File.delete("testfile.txt") if File.exists?("testfile.txt")

    @mock_feed_reader = MockFeedReader.new()
    @mock_feed_reader.mock_get_rss { RSS::Parser.parse("<rss version='1.0'><channel><title/><link/><description/><item><pubDate>Sat, 07 Sep 2002 00:00:01 GMT</pubDate><description>region</description></item></channel></rss>") }
  end

  def teardown
    File.delete("last_alert_time.txt") if File.exists?("last_alert_time.txt")
    File.delete("testfile.txt") if File.exists?("testfile.txt")	
  end

  def test_initialize_loads_config_and_has_early_last_alert_time
    feed_monitor = FeedMonitor.new("test_configs/config_1.yml", @mock_feed_reader)
    assert_equal(2, feed_monitor.feeds.length)
    assert_equal(4, feed_monitor.patterns.length)
    assert_equal("echo test > testfile.txt", feed_monitor.action)
    assert_equal(Time.parse("2000-12-31"), feed_monitor.get_last_alert_time)
  end

  def test_refresh_loads_feeds
    feed_monitor = FeedMonitor.new("test_configs/config_1.yml", @mock_feed_reader)
    assert(feed_monitor.refresh)
  end

  def test_refresh_doesnt_throw_on_bad_read
    @mock_feed_reader.mock_get_rss { raise "Argh!" }
    feed_monitor = FeedMonitor.new("test_configs/config_1.yml", @mock_feed_reader)
    assert(!feed_monitor.refresh)
  end

  def test_initialize_sets_alerts_empty_and_loads_last_alert_time
    original_time = Time.now
    feed_monitor = FeedMonitor.new("test_configs/config_1.yml", @mock_feed_reader)
    feed_monitor.set_last_alert_time(original_time)

    feed_monitor = FeedMonitor.new("test_configs/config_1.yml", @mock_feed_reader)
    assert_equal(0, feed_monitor.alerts.length)
    assert_equivalent(original_time, feed_monitor.get_last_alert_time)
  end
  
  def test_refresh_sets_alerts_full_and_updates_last_alert_time_and_performs_action
    original_time = Time.parse("2000-12-31")
    feed_monitor = FeedMonitor.new("test_configs/config_3.yml", @mock_feed_reader)
    feed_monitor.set_last_alert_time(original_time)

    assert(feed_monitor.refresh)
    assert(feed_monitor.alerts.length > 0)
    assert_not_equal(feed_monitor.get_last_alert_time, original_time)
    assert(File.exists?("testfile.txt"))
  end

  def test_perform_action
    feed_monitor = FeedMonitor.new("test_configs/config_1.yml", @mock_feed_reader)
    feed_monitor.perform_action()
    assert(File.exists?("testfile.txt"))
  end

  def test_perform_action_survives_nil_action
    feed_monitor = FeedMonitor.new("test_configs/config_5_BAD.yml", @mock_feed_reader)
    feed_monitor.perform_action()
  end

  def test_refresh_sets_alerts_empty_and_leaves_last_alert_time
    original_time = Time.now
    feed_monitor = FeedMonitor.new("test_configs/config_4.yml", @mock_feed_reader)
    feed_monitor.set_last_alert_time(original_time)

    assert(feed_monitor.refresh)
    assert_equal(0, feed_monitor.alerts.length)
    assert_equivalent(original_time, feed_monitor.get_last_alert_time)
  end
  
  def test_refresh_sets_alerts_full_subsequent_refresh_sets_alerts_empty
    feed_monitor = FeedMonitor.new("test_configs/config_3.yml", @mock_feed_reader)
    assert(feed_monitor.refresh)
    assert(feed_monitor.alerts.length > 0)
    assert(feed_monitor.refresh)
    assert_equal(0, feed_monitor.alerts.length)
  end

  private

  def assert_equivalent(x, y)
    assert_equal(x.hour, y.hour)
    assert_equal(x.min, y.min)
    assert_equal(x.sec, y.sec)
    assert_equal(x.yday, y.yday)
  end
end

class MockFeedReader  
  
  def mock_get_rss(&block)
    @block = block
  end

  def get_rss(uri)
    return @block.call
  end

end
