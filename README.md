Vagrant port forwarding info trigger
====================================

I find myself starting many vagrant boxes with webservers at the same time, and this helps me track which deployments are available on the particlar VM and which port was forwarded.

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

The `deployments.sh` file is a simple array of vhost names. You can modify this file, or just modify the `get-ports.sh` script directly with the deployment(s) that relate to your vagrant box.

If you do not want the SSH port info, or want to get the HTTPS forwarding details then you can just modify `get-ports.sh` to achieve this.
