# use-box-from-catalog example project

The key for this project:

## [Vagrantfile](https://github.com/xclusv/vagrant-boxer-example/blob/master/create-box-for-catalog/boxer.json)

This is just what you think it is.  The key here is that we tell Vagrant to use our custom
[vagrant-catalog](https://github.com/vube/vagrant-catalog)
server to fetch the base box from.

The two important lines from `Vagrantfile`:

```ruby
config.vm.box = 'xclusv/example'
config.vm.box_url = 'http://vagrant-boxer-example.xclusv.co/catalog/xclusv/example'
```
