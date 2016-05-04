# This example uses the Kasten Gem and byzanz (a small cli screencast creator)
# to let you select an area of your screen and then record a short GIF from it.
# You need to install byzanz first: sudo apt-get install byzanz

require 'kasten'

box = Kasten::Box.new

seconds = 5

puts "Recording GIF for #{seconds} seconds at #{box}"
system("byzanz-record -d #{seconds} -x #{box.x} -y #{box.y} -w #{box.w} -h #{box.h} -v -c recording.gif")
