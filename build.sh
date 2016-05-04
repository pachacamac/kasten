echo "--- COMPILING C LIB" && rake clean compile && echo "--- BUILDING GEM" && gem build kasten.gemspec && echo "--- INSTALLING GEM" && rake install
# publish with gem build kasten.gemspec && gem push kasten-0.1.0.gem
