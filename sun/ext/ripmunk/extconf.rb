ENV['RC_ARCHS'] = '' if RUBY_PLATFORM =~ /darwin/

require 'mkmf'

LIBDIR      = Config::CONFIG['libdir']
INCLUDEDIR  = Config::CONFIG['includedir']

HEADER_DIRS = [
  # First search /opt/local for macports
  '/opt/local/include',

  # Then search /usr/local for people that installed from source
  '/usr/local/include',
  '/usr/local/include/chipmunk',

  # Check the ruby install locations
  INCLUDEDIR,

  # Finally fall back to /usr
  '/usr/include',
]

LIB_DIRS = [
  # Then search /usr/local for people that installed from source
  '/usr/local/lib',

  # Check the ruby install locations
  LIBDIR,

  # Finally fall back to /usr
  '/usr/lib',
]

#stree_dirs = dir_config('stree', '/usr/local/include', '/usr/local/lib')
#
#unless ["", ""] == stree_dirs
#  HEADER_DIRS.unshift stree_dirs.first
#  LIB_DIRS.unshift stree_dirs[1]
#end

unless find_header('chipmunk/chipmunk.h', *HEADER_DIRS)
  abort "chipmunk is missing.  please install chipmunk"
end

unless find_library('chipmunk', 'cpAreaForPoly', *LIB_DIRS)
  abort "chipmunk is missing.  please install chipmunk"
end

create_makefile('ripmunk/ripmunk')
