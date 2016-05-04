require "mkmf"

have_library('X11') || raise
create_makefile("kasten/kasten")
