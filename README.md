# ActionCrud

ActionCrud speeds up development by making your controllers inherit all restful actions so you just have to focus on what is important. It makes your controllers more powerful and cleaner at the same time. In addition to making your controllers follow a pattern, it helps you to write better code by following fat models and skinny controllers convention.

[![Gem Version](https://badge.fury.io/rb/action_crud.svg)](https://badge.fury.io/rb/action_crud)
[![Build Status](https://travis-ci.org/hardpixel/action-crud.svg?branch=master)](https://travis-ci.org/hardpixel/action-crud)
[![Code Climate](https://codeclimate.com/github/hardpixel/action-crud/badges/gpa.png)](https://codeclimate.com/github/hardpixel/action-crud)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_crud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_crud

## Usage

To enable CRUD actions in an ActionController controller, include the `ActionCrud` concern in your class:

```ruby
class Post < ActionController::Base
  include ActionCrud
end
```

To set the controller model, use the `set_model_name` function:

```ruby
class Post < ActionController::Base
  # Using the set_model_name function
  set_model_name 'Post'

  # Or by setting the model_name class attribute
  self.model_name = 'Post'
end
```

To set a scope for the index action, use the `set_index_scope` function:

```ruby
class Post < ActionController::Base
  # Using the set_index_scope function
  set_index_scope :published

  # Or by setting the model_name class attribute
  self.index_scope = :published
end
```

To set the permitted parameters for the controller, use the `permit_params` function. The function accepts the options `only`, `except`, `also`, `array`, `hash`. Array and hash options are used to indicate array and hash parameters. If you call the function without options it will permit all the model attribute names except `id`:

```ruby
class Post < ActionController::Base
  # Using the permit_params function
  permit_params only: [:title, :content], array: [:categories, :tags]

  # Or by setting the permitted_params class attribute
  self.permitted_params = [:title, :content, [categories: []], [tags: []]]

  private

    # Or by overriding the record_params function
    def record_params
      params.require(:post).permit(:title, :content, [categories: []], [tags: []])
    end
end
```

After setting up the controller, like the examples above, you will have a fully working CRUD controller with instance variables `@post` and `@posts` available. Also, if you use a pagination gem like [SmartPagination](https://github.com/hardpixel/smart-pagination), the index records will be automagically paginated!

ActionCrud also injects in your views and controllers the following helpers:

| Paths              | URLs             | Data               | Tags (views only) |
| :----------------- | :--------------- | :----------------- | :---------------- |
| `records_path`     | `records_url`    | `current_model`    | `record_link_to`  |
| `record_path`      | `record_url`     | `current_record`   | `record_links_to` |
| `new_record_path`  | `new_record_url` | `current_records`  | &nbsp;            |
| `edit_record_path` | `edit_record_url`| `permitted_params` | &nbsp;            |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/action-crud.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
