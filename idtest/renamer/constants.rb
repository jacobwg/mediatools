module Renamer

  EXTS = %w(avi mpeg xvid mp4 m4v mkv wmv mpg)

  QUALITIES = [
    'cam', 'camrip',
    'ts', 'telesync',
    'scr', 'screener', 'dvdscr', 'dvdscreener',
    'r5',
    'ppvrip', 'ppv',
    'dvdrip',
    'dvdr', 'dvd',
    'hdtv', 'pdtv', 'dsr', 'dvb', 'tvrip', 'stv', 'dth',
    'bdrip', 'brrip', 'bluray', 'mkv', 'bdr', 'bd5', 'bd9'
  ]

  FORMATS = [
    'divx', 'xvid', 'x264', '264', 'mpeg', 'wmv'
  ]

end