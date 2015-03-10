
# Example vagrant-boxer and vagrant-catalog setup

This repository is an example of how to set up a [vagrant-catalog](https://github.com/vube/vagrant-catalog) server
and then use it in multiple vagrant projects.

In one project we create a base boxe that we then publish on the vagrant-catalog server using [vagrant-boxer](https://github.com/vube/vagrant-boxer).

In another, we then use that box as the basis for another VM.

See it in action: [vagrant-boxer-example.xclusv.co](http://vagrant-boxer-example.xclusv.co)

# Process Overview

- [Set up your vagrant-catalog server](#set-up-your-vagrant-catalog-server)
- [Set up your workstation](#set-up-your-workstation)
- [Create your new base box](#create-your-new-base-box)
- [Use your base box in another project](#use-your-base-box-in-another-project)

# Before we begin

You need to know the following information:

- Hostname/URL of your vagrant-catalog server (e.g. `vagrant-boxer-example.xclusv.co`)
- File location where to store Vagrant boxes on that server (e.g. `/data/www/xclusv.co/vagrant-boxer-example/files`)

In the example below, you will need to use your own versions instead of mine.
The ones I am showing you here upload to my example server.

# Set up your vagrant-catalog server

In this example I'm setting up the server `vagrant-boxer-example.xclusv.co` and I'm
putting it in the docroot `/data/www/xclusv.co/vagrant-boxer-example`

You should modify the commands below to use your own hostname and directory.

## Dependencies

The server must have the following software installed:

- Apache 2
- mod_rewrite enabled
- PHP 5.3+
- [PHP Composer](https://getcomposer.org/)

See [vagrant-catalog](https://github.com/vube/vagrant-catalog)
to see if there are any other dependencies since this README has last been updated.

I used `apt-get install apache2` on Debian, and I did nothing at all special to customize
Apache or its config files.

### Configuration files

#### /etc/apache2/sites-enabled/vagrant-boxer-example.xclusv.co

You need to make sure you enable your vagrant-catalog site, with a config
that looks something like this:

```text
<VirtualHost *:80>
    ServerName vagrant-boxer-example.xclusv.co
    DocumentRoot /data/www/xclusv.co/vagrant-boxer-example
    <Directory /data/www/xclusv.co/vagrant-boxer-example>
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
```

The important parts are that we grant access to the world (you may want to restrict this),
and we `AllowOverride All` which allows the `.htaccess` file in the vagrant-catalog
source enable its mod_rewrite rules.

## Check out and initialize vagrant-catalog

```bash
root@server$ mkdir -p /data/www/xclusv.co
root@server$ cd /data/www/xclusv.co
root@server$ git clone https://github.com/vube/vagrant-catalog vagrant-boxer-example
root@server$ cd vagrant-boxer-example
root@server$ composer install --no-interaction --no-dev --optimize-autoloader
```

There is no need to modify the config.php, we are using the default setup in this example.

### Make sure your user/group has access to upload

```bash
root@server$ install -d -m 0775 -g staff /data/www/xclusv.co/vagrant-boxer-example/files
```

Here I set the entire directory as group-writable by the `staff` group,
you should obviously change that to suit your needs.


### Verify the web site is loading correctly

Point your browser at [http://vagrant-boxer-example.xclusv.co/](http://vagrant-boxer-example.xclusv.co/)
(substitute your own hostname).

You should see it returning non-error output, it probably says "Vagrant Catalog" at the top.

Tip: Make sure you restart Apache any time you make config changes or enable/disable modules.

If you see an error (or if you don't see anything at all) then check your server's error_logs
for hints as to what might be going wrong.


# Set up your workstation

* Install [VirtualBox](http://www.virtualbox.org/)
* Install [Vagrant](http://vagrantup.com/) (1.6.5 or newer)
* Clone this repository and update its submodules

```bash
you@workstation$ cd ~
you@workstation$ git clone https://github.com/xclusv/vagrant-boxer-example
you@workstation$ cd vagrant-boxer-example
you@workstation$ git submodule update --init --recursive
```

## Initialize vagrant-boxer

Here I'm assuming that you do not have vagrant-boxer already installed on your system
in a globally executable location, so I've included it as a sub-module to this example
and we need to initialize it via composer.

```bash
you@workstation$ cd ~/vagrant-boxer-example/create-box-for-catalog/vagrant-boxer
you@workstation$ composer install --no-interaction --no-dev --optimize-autoloader
```

# Create your new base box

The [create-box-for-catalog](create-box-for-catalog) directory contains a sample project that creates a new base
box and keeps it updated on your vagrant-catalog server.

See the [README](create-box-for-catalog/README.md) in that directory for more info.

To create your new base box, we'll base it on the `chef/debian-7.4` image from
Vagrant Cloud, and then do some custom provisioning to make it your own.

In practise you'll want to change the Vagrantfile to do whatever other customization you
require in your box, but for now all we do is change `/etc/motd`.

```bash
you@workstation$ cd ~
you@workstation$ cd vagrant-boxer-example/create-box-for-catalog
you@workstation$ vagrant up
you@workstation$ php vagrant-boxer/boxer.php --verbose
```

The `--verbose` flag is not strictly necessary, but it helps give a better idea of what
is going on, especially since exporting and uploading can take a really long time.

Note: This has now generated or updated a `metadata.json` file.

I recommend that you keep this metadata.json as part of your SCM.  It contains a list of
all the possible versions of the boxes you have generated and published to your vagrant-catalog.

You can manually edit this file at any time to remove one or more versions that you
do not wish people to use.

## Note about your first upload

Note that the first time you try to upload, you may get an error depending on your ssh
security settings.  In general you might see that it gets stuck at this point:

```bash
you@workstation$ php vagrant-boxer/boxer.php --verbose
EXEC: vagrant package --output "./package.box" --base "example"
==> example: Exporting VM...
==> example: Compressing package to: C:/vagrant-boxer-example/create-box-for-catalog/package.box
PACKAGE LOCATION: ./example-1.0.0-virtualbox.box
METADATA LOCATION: metadata.json
EXEC: ssh "vagrant-boxer-example.xclusv.co" "mkdir -p -m 0775 /data/www/xclusv.co/vagrant-boxer-example/files/xclusv/example/"
```

The ssh line never completes.  I then ran that command manually, and I was told the following:

```bash
you@workstation$ ssh "vagrant-boxer-example.xclusv.co" "mkdir -p -m 0775 /data/www/xclusv.co/vagrant-boxer-example/files/xclusv/example/"
The authenticity of host 'vagrant-boxer-example.xclusv.co (104.154.48.182)' can't be established.
RSA key fingerprint is 3d:a9:62:f5:08:bb:08:ee:bc:1c:b5:d6:ba:41:0a:18.
Are you sure you want to continue connecting (yes/no)? yes
```

I typed 'yes', that saved the key, and then vagrant-boxer is working fine.  I ran it again
and it started to upload correctly.

```bash
you@workstation$ php vagrant-boxer/boxer.php --verbose
```


## Updating your base box

You can update your box very similarly.  The following steps will:

- Re-provision
- Re-export
- Bump your internal box version number (rewriting metadata.json)
- Upload the new version of the box and metadata.json to your vagrant-catalog server

```bash
you@workstation$ cd ~
you@workstation$ cd vagrant-boxer-example/create-box-for-catalog
you@workstation$ vagrant provision
you@workstation$ php vagrant-boxer/boxer.php --verbose
```


# Use your base box in another project

The [use-box-from-catalog](use-box-from-catalog) directory shows an example second project that wishes
to use the base box you created.

See the [README](use-box-from-catalog/README.md) in that directory for more info.

This is very simple, the `Vagrantfile` is the only thing you need to look at, and in particular
these 2 lines:

```ruby
config.vm.box = 'xclusv/example'
config.vm.box_url = 'http://vagrant-boxer-example.xclusv.co/catalog/xclusv/example'
```

These lines MUST match the values that you are using in the `boxer.json` config in the
`create-box-for-catalog` project.
