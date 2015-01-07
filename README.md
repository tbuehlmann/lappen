# Lappen

TODO.

## Requirements

- Ruby ≥ 1.9.3
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

## Usage

### Defining a Lappen

Inside your Rails application, define a subclass of `Lappen::FilterStack` for a Model you want to lappen. Inside this FilterStack (or: "Lappen"), use the class method `use` to configure the Filters that shall be used:

```ruby
class ProductLappen < Lappen::FilterStack
  use Lappen::Filters::Kaminari
  use Lappen::Filters::Orderer
end
```

This Lappen will use the Filters `Kaminari` and `Orderer` (in exactly this order).

A suitable location to place Lappens is `app/lappens`. This will also be the default for Lappens created via the generators later on.

### Using a Lappen

After defining a Lappen, you can use it in your controller:

```ruby
class ProductsController < ApplicationController
  def index
    @products = ProductLappen.perform(Product.all, params)
  end
end
```

`ProductLappen.perform` will apply any Filter you configured in the Lappen on the scope you provided as the first argument. In order to do their work, Filters get access to the `params` object you can provide as the second argument.

When using ActiveRecord, all Models will get a shortcut class method for free. Having a Model (or relation for) `Product` with a Lappen `ProductLappen`, you can simply call `Product.lappen(params)`. This works internally by appending the word "Lappen" to the calling Model. If you want to use the shortcut with a different Lappen, define a class method `lappen_class` on the Model:

```ruby
class Product < ActiveRecord::Base
  class << self
    def lappen_class
      MyProductLappen
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

… and add the Filter to your Lappen:

```ruby
class ProductLappen < Lappen::FilterStack
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
