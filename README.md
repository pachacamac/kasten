# Kasten

Let users draw a Kasten (German for box) in an X environment and get it's dimensions

## Usage

run `gem install kasten` or add it to your Gemfile and run bundle install, then:

    require 'kasten'

    dimensions = Kasten.kasten
    p dimensions


Yes, it's that simple.

If the Gem doesn't compile for you, you might need to install libx11-dev. So on Debian based systems do `sudo apt-get install libx11-dev` first.
