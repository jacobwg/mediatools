# Media Tools

* `process_with_edl` - mute/skip parts of a given video file with an edl list (uses mencoder)

## Requirements

I've only tested this on Mac OS X Lion and a current version of Arch - will probably work on other systems, though (probably not windows without some serious hacking).

* ruby (use `rvm`)
* perl
* python
* mplayer / mencoder (`brew install mplayer`)
* mkvtoolnix (`brew install mkvtoolnix`)

I'll be working on standardizing stuff so that there's not so many redundant dependencies.