echo "--- COMPILING C LIB" && rake clean compile && echo "--- BUILDING GEM" && gem build kasten.gemspec && echo "--- INSTALLING GEM" && rake install
# publish with: rake publish
