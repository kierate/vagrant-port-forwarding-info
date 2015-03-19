Vagrant port forwarding info trigger
====================================

If you find starting many vagrant boxes with webservers at the same time (like I do), then this vagrant trigger will can help you track which VMs use which ports.
It also shows you what deployments are available on the particular VM.

Installation
------------

First you need to install the [vagrant-triggers plugin](https://github.com/emyl/vagrant-triggers):

```shell
$ vagrant plugin install vagrant-triggers
```

Once you have the plugin add the following section to your Vagrantfile:

```ruby
  # Get the ports details at more useful places
  # - after "vagrant up" and "vagrant resume"
  config.trigger.after [:up, :resume] do
    run "#{File.dirname(__FILE__)}/get-ports.sh #{@machine.id}"
  end
  # - before "vagrant ssh"
  config.trigger.before :ssh do
    run "#{File.dirname(__FILE__)}/get-ports.sh #{@machine.id}"
  end
```

This will trigger the `get-ports.sh` script which will show you how the ports are forwarded for any deployments you have configured.

Modifying
---------

The `deployments.sh` file is a simple array of vhost names. You can modify this file, or just modify the `get-ports.sh` script directly with the deployment(s) that relate to your vagrant box. (I keep the deployments list separated out only because it's also used by the main provisioning script.)

If you do not want the SSH port info, or want to get the HTTPS forwarding details then you can just modify `get-ports.sh` to achieve this.
