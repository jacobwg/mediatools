# Media Tools

* `process_with_edl` - mute/skip parts of a given video file with an edl list (uses mencoder)

## Subfolders / Subprojects

* hulu-subs-decryption - decryption for Hulu's subtitles (only the perl version works)
* p1013 - original scripts for movie filtering
* php-hulu-filter - php version of hulu.tmfdb.org (probably doesn't work)
* xbmcfilter - idea to filter XBMC videos based on HTTP API (proof of concept)

## Requirements

I've only tested this on Mac OS X Lion and a current version of Arch - will probably work on other systems, though (probably not windows without some serious hacking).

* ruby (use `rvm`)
* perl
* python
* mplayer / mencoder (`brew install mplayer`)
* mkvtoolnix (`brew install mkvtoolnix`)
* mediainfo (`brew install mediainfo`)
* mp4box (`brew install mp4box`)
* exiftool (`brew install exiftool`)

Gems:

* mediainfo

I'll be working on standardizing stuff so that there's not so many redundant dependencies.