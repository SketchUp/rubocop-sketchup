# Installation

## Requirements

* Standalone Ruby 2.5+ installation on the system. This is not intended to be used inside of SketchUp. Mac users should have Ruby already on the system, but might find it beneficial to use [RVM](https://rvm.io/). Windows users need to install Ruby from https://rubyinstaller.org/.

* The [RuboCop](http://batsov.com/rubocop/) gem must also be installed.

    ```sh
    gem install rubocop
    ```

## Install

Install the `rubocop-sketchup` gem:

```sh
gem install rubocop-sketchup
```

## Bundler

If you use [bundler](http://bundler.io/) to manage you're project's dependencies put this in your Gemfile:

```ruby
gem 'rubocop', '>= 0.82', '< 2.0'
gem 'rubocop-sketchup', '~> 1.3.0'
```
