# Custom Widgets
Custom widgets are modified vicious widgets. You can load them after you require Vicious:

``` lua
vicious = require("vicious")
custom_widgets = require("custom_widgets")
```

## Usage
Usage is similar to the usual vicious widgets with a different type name, e.g., `custom_widgets.wifi` for the wifi widget.

### Widget types
#### custom_widgets.wifi
The only difference from the viciuos wifi widget is that I added `sudo` in front of the command which queries the wifi state, because I could not figure out how to do that without using `sudo`. The widget uses the `iwconfig` command and you need to configure it to require no password. To do this, you can add a file to `/etc/sudoers.d/` and add the following line:

    <user_name> <host_name> = NOPASSWD: /sbin/iwconfig

Use `sudo visudo -f /etc/sudoers.d/<file_name>` to edit the file to ensure that the file has the correct permission.
