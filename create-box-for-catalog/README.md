# create-box-for-catalog example project

The keys for this project:

## [Vagrantfile](https://github.com/xclusv/vagrant-boxer-example/blob/master/create-box-for-catalog/boxer.json)

This is just what you think it is.  This doesn't do anything special, it just creates your base box from some other
base box (in our case, Vagrant Cloud's `chef/debian-7.4` image).

## [boxer.json](https://github.com/xclusv/vagrant-boxer-example/blob/master/create-box-for-catalog/boxer.json)

`boxer.json` is the config for [vagrant-boxer](https://github.com/vube/vagrant-boxer)
which determines the names and URLs boxes will use in your [vagrant-catalog](https://github.com/vube/vagrant-catalog)

For more details on the values you can put in this file and what they mean, currently you need to dig into the
[Boxer.php source](https://github.com/vube/vagrant-boxer/blob/master/src/Vube/VagrantBoxer/Boxer.php).  (I know,
shame on me for not writing docs.)

## [metadata.json](https://github.com/xclusv/vagrant-boxer-example/blob/master/create-box-for-catalog/metadata.json)

`metadata.json` is a file that should NOT exist when you create your project.  Don't worry about what goes there,
just delete the file if you copy this to your own project.

It is created and subsequently updated whenever you run `vagrant-boxer` and generally you don't
need to worry about it at all.  Do commit it to your SCM so you'll have the history of box versions
you created and their checksums.

If/when you see that there are many versions, you can manually prune entries from the
versions array to just keep relevant/recent ones.
