#!/usr/bin/env ruby

# This example uses the Kasten Gem and several Unix tools to allow you to
# interactively draw colored, annotated areas on (a copy of) your XFCE desktop wallpaper.
# It utilizes:
# - zenity for interactive dialog boxes and the color picker
# - xfconf to get and set your XFCE desktop wallpaper
# - xrandr to get the current screen resolution
# - imagemagick to manipulate the wallpaper

require 'kasten'

system("zenity --info --text='To create an annotation draw a box around the area you want to annotate!'")

loop do
  box = Kasten::Box.new
  text = `zenity --entry --text='Please enter a label for that area'`.chomp
  color = `zenity --color-selection`.chomp
  r, g, b, a = (color.empty? ? '127,127,127' : color).scan(/(\d+),(\d+),(\d+)(?:,([\d\.]+))?/).first
  a ||= 1
  wp_current = `xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image`.chomp
  c_width, c_height = `identify #{wp_current}`.scan(/(\d+)x(\d+)/).first.map(&:to_f)
  s_width, s_height = `xrandr`.scan(/current (\d+) x (\d+)/).first.map(&:to_f)
  fw, fh = c_width / s_width, c_height / s_height
  x1, y1, x2, y2 = box.x * fw, box.y * fh, (box.x + box.w) * fw, (box.y + box.h) * fh
  wp_new = File.expand_path(File.join(File.dirname(wp_current), '_wp_annotated.jpg'))
  system([
    "convert '#{wp_current}'",
    "-strokewidth 0 -fill \"rgba(#{r},#{g},#{b},#{a})\"",
    # "-draw \"rectangle #{x1},#{y1} #{x2},#{y2}\"",
    "-draw \"roundrectangle #{x1},#{y1} #{x2},#{y2} 5,5\"",
    "-font Helvetica -pointsize 24 -draw \"text #{x1+2},#{y1-2} '#{text}'\"",
    "'#{wp_new}'"
    ].join(' ')
  )
  system("xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s '#{wp_new}'")
  break unless system("zenity --question --text 'Would you like to create another annotation?'")
end

