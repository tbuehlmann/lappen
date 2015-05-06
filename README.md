# Lappen

[![Gem Version](https://badge.fury.io/rb/lappen.svg)](http://badge.fury.io/rb/lappen) [![Code Climate](https://codeclimate.com/github/tbuehlmann/lappen/badges/gpa.svg)](https://codeclimate.com/github/tbuehlmann/lappen) [![Build Status](https://travis-ci.org/tbuehlmann/lappen.svg?branch=master)](https://travis-ci.org/tbuehlmann/lappen)

## Rationale

```ruby
class ProductsController < ApplicationController
  def index
    @products = policy_scope(Product.active).with_name(params[:name]).ordered_by(params[:order]).page(params[:page]).per(params[:per]).includes(:reviews).decorate
  end
end
```

Ever faced code like this? Right, me too. And I don't like it.

This Library targets the problem of polluted controller actions by abstracting the method chaining in a middleware-oriented fashion.

## Requirements

- Ruby  ~> 2.0
- Rails ~> 4.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lappen', github: 'tbuehlmann/lappen'
```

And then execute:

```sh
$ bundle install
```

Optionally create an `ApplicationFilterStack` from which all Filter Stacks can inherit from by running:

```sh
$ bin/rails generate lappen:install
```

## Usage

### Defining a Filter Stack

Inside your Rails application, define a subclass of `Lappen::FilterStack` for a Model you want to run Filters on. Inside this Filter Stack, use the class method `use` to configure the Filters that shall be used:

```ruby
class ProductFilterStack < Lappen::FilterStack
  use Lappen::Filters::Kaminari
  use Lappen::Filters::Orderer
end
```

This Filter Stack will use the Filters `Kaminari` and `Orderer` (in exactly this order).

A suitable location to place Filter Stacks is `app/filter_stacks`. This is also the default location for Filter Stacks created via the generators.

If you want to create a Filter Stack for a specific Model, use the `filter_stack` generator:

```sh
$ bin/rails generate lappen:filter_stack product
```

### Using a Filter Stack

After defining a Filter Stack, you can use it in your controller:

```ruby
class ProductsController < ApplicationController
  def index
    @products = ProductFilterStack.perform(Product.all, params)
  end
end
```

`ProductFilterStack.perform` will apply any Filter you configured in the Filter Stack on the scope you provided as the first argument. In order to do their work, Filters get access to the `params` object you can provide as the second argument.

When using ActiveRecord, all Models will get a shortcut class method for free. Having a Model (or relation for) `Product` with a Filter Stack `ProductFilterStack`, you can simply call `Product.lappen(params)`. This works internally by appending "FilterStack" to the calling Model. If you want to use the shortcut with a different Filter Stack, define a class method `filter_stack_class` on the Model:

```ruby
class Product < ActiveRecord::Base
  class << self
    def filter_stack_class
      MyProductFilterStack
    end
  end
end
```

Here will be a link to a list of built-in Filters later on.

### Writing a Filter

If you want to write and use your own Filter, create a class following the common interface:

```ruby
class MyFilter
  def initialize(stack, *args)
    # …
  end

  def perform(scope, params = {})
    # …
  end
end
```

… and add the Filter to your Filter Stack:

```ruby
class ProductFilterStack < Lappen::FilterStack
  use Lappen::Filters::Kaminari
  use Lappen::Filters::Orderer
  use MyFilter
end
```

Any further arguments are injected into the Filter's constructor:

```ruby
  use MyFilter, :foo, :bar
```

… will initialize the Filter as `MyFilter.new(stack, :foo, :bar)`.

In order to save you some time, there's already a class following the interface you can inherit from:

```ruby
class MyFilter < Lappen::Filter
  # …
end
```

This class will also extract Hash options from `args`, giving you `args` and `options` getter methods.

#### Returning Early

Normally, each Filter runs `stack.perform(scope, params)` at the end of its `perform` method to tell the next Filter to run. If you want to stop further filtering (for whatever reason), simply return the scope instead of calling `stack.perform(scope, params)`.

### Request Context

There are times in life you need to use information from the current request in your Filter. In order to do so, `Lappen::Filter` includes the `Lappen::RequestContext` module, which enables you to use the private `controller` and `view_context` methods. Using these you can for example access the commonly used `current_user` method:

```ruby
class MyFilter < Lappen::Filter
  def perform(scope, params = {})
    # …
  end

  private

  def current_user
    view_context.current_user
  end
end
```
