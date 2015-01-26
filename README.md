# Unicorn-Build-Indicator

This is a simple jenkins build check that makes use of the [Unicorn Hat](http://shop.pimoroni.com/products/unicorn-hat) from PiMoroni plugged into a Raspberry Pi running raspbian.

This relies on the C daemon from the [UnicornHat](https://github.com/pimoroni/UnicornHat/tree/master/c/unicornd) repository being installed.

```bash
  sudo apt-get install cpanminus
  cpanm Jenkins::API List::Util
  # now go for a meal, this may take a while.  
  # repeat the previous command if it fails, 
  # the depedendency chain doesn't appear to be perfect when installing on the Pi.
```

Then run the script with the url, the username and auth token.  If you don't require authorization on your jenkins ommit the username and password.

`jenkins_status.pl http://jenkins:8080/ user authtoken`

The simplest thing to do then is to run the script in a cron job.

The script is currently setup to check the views on the Jenkins and check all the jobs pass their tests.  That allows us to avoid jobs we don't care about by not having them in views.
