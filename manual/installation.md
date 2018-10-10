**RuboCop**'s installation is pretty standard:

```sh
$ gem install rubocop -v 0.58.1
$ gem install rubocop-sketchup
```

RuboCop's development is moving at a very rapid pace and there are
often backward-incompatible changes between minor releases (since we
haven't reached version 1.0 yet). To prevent an unwanted RuboCop update you
might want to use a conservative version locking in your `Gemfile`:

```rb
gem 'rubocop', '~> 0.58.1'
gem 'rubocop-sketchup', '~> 0.4.1'
```
