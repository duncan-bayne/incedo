incedo
======
incedo is a simple CLI tool to monitor RSS feeds, and take action when certain keywords arise in items.

incedo was originally created to monitor the CFA Incident Updates and Advice feed during bushfire season, and the default configuration file is set up to monitor two CFA RSS feeds and notify on certain suburbs turning up in the feed items.

WARNING
=======
I have been informed that on busy days (i.e. when there are a lot of fires to fight - literally speaking) there can be a lag of an hour or more between an incident, and that incident appearing in the CFA RSS feed.

This shouldn't need spelling out, but: don't rely solely on Incedo. Have a fire plan well in advance, prepare your property as best you can, and on high risk days keep watch yourself. You may be the first to see a threat!

For more information, visit the CFA website.

status
------
31 Dec 2010: The CFA has moved one of their RSS feeds; I have updated the configuration files appropriately.

07 Sep 2010: As far as I can tell, the CFA has fixed the item publication date on their RSS Incident Summary feed.

02 Feb 2010: The CFA's RSS Incident Summary feed is currently broken; all items are reporting the same recent publication date. I am in touch with the CFA to resolve this.

licence
-------
incedo is licensed under the GNU Lesser General Public License.

### why the LGPL?
The GPL is specifically designed to reduce the usefulness of GPL-licensed code to closed-source, proprietary software. The BSD license (and similar) don't mandate code-sharing if the BSD-licensed code is modified by licensees. The LGPL achieves the best of both worlds: an LGPL-licensed library can be incorporated within closed-source proprietary code, and yet those using an LGPL-licensed library are required to release source code to that library if they change it.

installation
------------

### windows
1. install Ruby from the [Windows One-Click Installer](http://www.ruby-lang.org/en/downloads/)
2. install [Git for Windows](http://code.google.com/p/msysgit/)
3. clone git://github.com/duncan-bayne/incedo.git

### linux
1. install Ruby, Git and mplayer
2. clone git://github.com/duncan-bayne/incedo.git

configuration
-------------
Use a text editor to edit config.yml.

Ensure that all the keywords you want to be alerted about are present in the list uncomment the action section appropriate to your operating system (either Windows or Linux).

execution
---------
Run incedo.rb.

thanks
------
+ [The CFA](http://www.cfa.vic.gov.au/)
+ [Ruby](http://www.ruby-lang.org/en/)
+ [Emacs](http://www.gnu.org/software/emacs/)

