Magento cookbook
================

## Description

This project-specific cookbook for the [Chef provisioner][Chef] is intended to extend the [Ariadne development environment][Ariadne] for working on [Magento][Magento] projects.

## Requirements

This cookbook requires at least the following cookbooks have been installed on the machine being provisioned:

* apache2
* apt
* phpmysql

## Usage

First, set up the Ariadne VM development environment as per it's quick-start instructions. The commands below assume you are using the bundler zsh plugin, set up as explained in the Ariadne README. If not, simply proceed each command with `bundle exec` to execute it with the gems bundled in the Ariadne sandbox.

    $ git clone --branch release/1.0.0 git@github.com:myplanetdigital/ariadne.git
    $ cd path/to/ariadne
    $ rake setup
    $ rake init_project[myplanetdigital/ariadne-magento]
    $ project=magento vagrant up # or `vagrant reload`

This will set `project = magento` in `config/config.ini`, which will be used for future `vagrant` commands.

`project=magento vagrant reload` should work as well if the VM is already created. `provision` will also work, but you should be wary that Vagrant will need to start sharing a new `cookbooks` directory when first added, and that requires a `reload`.

## To Do

* Test whether [restarting apache immediately after xdebug template](https://github.com/myplanetdigital/chef-xdebug/blob/create-logfile/recipes/default.rb#L39) removes confusing first-run output.


[Chef]: http://www.opscode.com/chef/
[Ariadne]: https://github.com/myplanetdigital/ariadne
[Magento]: http://www.magentocommerce.com/
