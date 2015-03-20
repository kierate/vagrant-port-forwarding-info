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

The last step is to copy the `get-ports.sh` and `deployments.sh` files from this repo to wherever your `Vagrantfile` is located.


How does it work
----------------

Once installed the `get-ports.sh` script will be triggered after each `vagrant up` and `vagrant resume` as well as before each `vagrant ssh`. This will show you how the ports are forwarded for any deployments you have configured.

The output will be something along these lines:

```
==> default: Executing command "/path/vagrant/get-ports.sh af6-2571-4353-a829-8578"...
==> default:  
==> default:  
==> default: Available deployments can be accessed on the following URLs:
==> default:     http://system1.local:8080
==> default:     http://example.vagrant:8080
==> default:     http://test:8080
==> default:     http://test2:8080
==> default:     http://foo.lo:8080
==> default:  
==> default: You can ssh into the machine in one of the following ways:
==> default:     vagrant ssh                     (within the vagrant directory)
==> default:     ssh vagrant@localhost -p 2222   (from anywhere)
==> default:     ssh root@localhost -p 2222      (from anywhere)
==> default:  
==> default:  
==> default: Command execution finished.
```

Modifying
---------

The `deployments.sh` file is a simple array of vhost names. You can modify this file, or just modify the `get-ports.sh` script directly with the deployment(s) that relate to your vagrant box. (I keep the deployments list separated out only because it's also used by the main provisioning script.)

If you do not want the SSH port info, or want to get the HTTPS forwarding details then you can just modify `get-ports.sh` to achieve this.


Making it available for all your Vagrant boxes
----------------------------------------------

If you keep the `get-ports.sh` script generic (i.e. applicable to all your Vagrant boxes) then you can just copy it to a directory within your `PATH` and modify each `Vagrantfile` along these lines:

```ruby
  config.trigger.after [:up, :resume] do
    run "get-ports.sh #{@machine.id}"
  end
```

Bear in mind that with this approach you won't have access to any config specific to an individual Vagrant box (without some exter steps e.g. passing in `#{File.dirname(__FILE__)}` as a parameter to `get-ports.sh`), and also this makes your Vagrant file less portable.
