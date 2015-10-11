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

This Library targets the problem of Scope filtering (and polluted controller index actions) by abstracting the method chaining in a middleware-oriented fashion.

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

A list of built-in Filters is available in the [Wiki](https://github.com/tbuehlmann/lappen/wiki).

### Writing a Filter

If you want to write and use your own Filter, create a class following the common interface:

```ruby
class MyFilter
  def initialize(*args, **options)
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
  use MyFilter, :foo, bar: 'baz'
```

… will initialize the Filter as `MyFilter.new(:foo, bar: 'baz')`.

In order to save you some time, there's already a class following the interface you can inherit from:

```ruby
class MyFilter < Lappen::Filter
  # …
end
```

Inside the class you have access to `args` and `options` getter methods referencing the initialized arguments.

#### Returning Early

Normally, the FilterStack runs each Filter after another, using a filter's output as the next filter's input. If you want to stop further filtering (for whatever reason), throw `:halt` with the result scope:

```ruby
class MyFilter < Lappen::Filter
  def perform(scope, params = {})
    if some_condition
      throw(:halt, scope.none)
    else
      # …
    end
  end
end
```

Throwing `:halt` will stop the FilterStack from running any further Filter and the throwed scope will be returned.

### Request Context

There are times in life you need to use information from the current request in your Filter. In order to do so, `Lappen::Filter` includes the `Lappen::RequestContext` module, which enables you to use the private `controller` and `view_context` methods. Using those you can for example access the commonly used `current_user` method:

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

### Callbacks

When including `Lappen::Callbacks` into a FilterStack, it will support (before/around/after) Callbacks in order to be able to hook into filtering actions. There are two actions to hook into: the `:perform` and the `:filter` action.

The Callbacks for the `:perform` action are run when calling `FilterStack.perform`. They surround the calling of all the FilterStack's Filters.

The Callbacks for the `:filter` action are run when single Filters are called by a FilterStack. They surround just the filter's performing.

Example for the `:perform` action:

```ruby
class ProductFilterStack < Lappen::FilterStack
  include Lappen::Callbacks

  before_perform { puts 'before' }
  after_perform  { puts 'after' }

  around_perform do |filter_stack, block|
    puts 'around before'
    block.call
    puts 'around after'
  end
end

ProductFilterStack.perform(scope = {})

# before
# around before
# around after
# after
```

In order to access the Filter currently being performed on a `:filter` action, call `filter`.

Callbacks are available in subclasses dynamically. Defining a Callback in a superclass will make it available in its subclasses, even if they were already defined.

### Notifications

If you want to fanout `ActiveSupport::Notifications` on the performings of a FilterStack and single Filters, include the `Lappen::Notifications` module into your FilterStack:

```ruby
class ProductFilterStack < Lappen::FilterStack
  include Lappen::Notifications
end
```

By doing so, Notification Events with the keys `'lappen.perform'` and `'lappen.filter'` will be sent. You can subscribe to these Events like this:

```ruby
ActiveSupport::Notifications.subscribe('lappen.perform') do |name, start, finish, id, payload|
  puts payload[:filter_stack]
end

ActiveSupport::Notifications.subscribe('lappen.filter') do |name, start, finish, id, payload|
  puts payload[:filter_stack]
  puts payload[:filter]
end
```

There is always a `:filter_stack` key available in the payload, returning the performing FilterStack instance. When subscribing to `'lappen.filter'`, you can additionally access the performing Filter instance using the `:filter` key.

As `Lappen::Notifications` uses Callbacks internally, subclasses of a class that has the `Lappen::Notifications` module included will also instrument Notifications.
