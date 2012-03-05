# Media Tools

* `bin/2avi` - converts an arbitrary number of video files to AVI files
* `bin/make_edl`
* `bin/mkv2avi` - uses mkvextract and ffmpeg to convert mkv's to avi's (probably best to do this manually)
* `bin/process_with_edl` - mute/skip parts of a given video file with an edl list (uses mencoder)
* `bin/search_reviews` - searches PluggedIn and Kids in Mind for reviews for a given movie
* `bin/srename` - convenience script for mass-renaming TV seasons
* `bin/torrent_search` - searches The Pirate Bay for a given TV show and parses the results into seasons, episodes, formats, and quality (partially complete RSS feed generation too)

## Subfolders / Subprojects

* hulu-subs-decryption - decryption for Hulu's subtitles (only the perl version works)
* media-finder - searches NZBMatrix for a given TV show
* p1013 - original scripts for movie filtering
* php-hulu-filter - php version of hulu.tmfdb.org (probably doesn't work)
* xbmcfilter - idea to filter XBMC videos based on HTTP API (proof of concept)

## Requirements

I've only tested this on Mac OS X Lion and a current version of Arch - will probably work on other systems, though (probably not windows without some serious hacking).

* ruby (use `rvm`)
* perl
* python
* mplayer / mencoder (`brew install mplayer`)
* ffmpeg (`brew install ffmpeg --use-gcc`)
* mkvtoolnix (`brew install mkvtoolnix`)
* mediainfo (`brew install mediainfo`)
* mp4box (`brew install mp4box`)
* exiftool (`brew install exiftool`)

Gems:

* mediainfo

I'll be working on standardizing stuff so that there's not so many redundant dependencies.