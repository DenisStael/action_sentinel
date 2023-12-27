# ActionSentinel

Simple authorization of controller actions based on model-level permissions.

This gem enables access authorization control, based on the access permission settings for each controller and its actions, at the model level.

## Installation

### 1. Add the gem into your project

Add this to your Gemfile and run `bundle install`.

```ruby
gem 'action_sentinel'
```

Or install it yourself as:
```sh
gem install action_sentinel
```

### 2. Generate AccessPermission Model

Use the ActionSentinel generator to create the AccessPermission model and its relationship, which AccessPermission will belong to. You must specify the name of the model that will have access permissions. For example, if you want to set permissions to a User model, you can use:

```
rails g action_sentinel:access_permission User
```

If your database uses UUID for the primary and foreign keys, you can pass the `--uuid` option:

```
rails g action_sentinel:access_permission User --uuid
```

The generator will create the AccessPermission model and a migration, and insert into your User class the method `action_permissible`, which includes the new methods and associates the model with the access permissions:

```ruby
# AccessPermission model
class AccessPermission < ApplicationRecord
  belongs_to :user

  validates :controller_path, uniqueness: { scope: :user_id }
end

# User model with permissions added
class User < ApplicationRecord
  action_permissible
end

```

### 3. Run the migration

```
rails db:migrate
```

### 4. Include authorization in ApplicationController

Include `ActionSentinel::Authorization` into your application controller:

```ruby
class ApplicationController < ActionController::Base
  include ActionSentinel::Authorization
end
```

## Usage

### Adding permissions

It is possible to add one or more permissions to access a controller, calling:

```ruby
# Adding permission to access show action in UsersController
user.add_permissions_to 'show', 'users'

# Adding permissions to access create and update actions in UsersController
user.add_permissions_to 'create', 'update', 'users'
```
The arguments must be related to the actions of a controller, and the last argument is the name of the controller. The actions arguments must be in downcase format and must be equal to the actions methods of the controller. The controller argument, must be in downcase and plural format, ignoring the "Controller" suffix. 

For example, a controller called `UsersController` must be passed just as `users`.

Also is possible to pass the arguments as symbols:
```ruby
user.add_permissions_to :create, :update, :users
```

### Removing permissions

It is possible to remove one or more permissions to access a controller, calling:

```ruby
# Removing permission to access create action in UsersController
user.remove_permissions_to 'create', 'users'

# Removing permissions to access create and update actions in UsersController
user.remove_permissions_to 'create', 'update', 'users'
```

### Checking if has permission to access an action

To check if the user has permission to access an action from a controller, you just need to call the method `has_permission_to?` passing the action and the controller as argument:

```ruby
user.has_permission_to? 'create', 'users'
```

### Scoped Controllers

For controllers that are scoped in a module, its argument also must be informed in the same downcase and plural format, but with the prefix of the module separated by a slash. For example, a controller called `Api::UsersController` must be passed as `api/users`:

```ruby
# Adding permissions
user.add_permissions_to 'create', 'update', 'api/users'

# Removing permissions
user.remove_permissions_to 'create', 'update', 'api/users'

# Checking permission
user.has_permission_to? 'create', 'api/users'
```

## Authorization

To authorize the actions in a controller, you must call `authorize_action!`. Action Sentinel will authorize the access if the current user has permission to access the action.

```ruby
def create
  authorize_action!
  
  # implementation code
end
```

Also can be called in `before_action` method:

```ruby
before_action :authorize_action!
```

### Action User

The authorization module expects that a `current_user` method exists into your controller (if you are using devise for example), but you can override `action_user` method to reflect your current user:

```ruby
class ApplicationController < ActionController::Base
  include ActionSentinel::Authorization

  protected

  def action_user
    your_current_user
  end
end
```

### Rescuing an UnauthorizedAction in ApplicationController

Action Sentinel raises an `ActionSentinel::UnauthorizedAction` if the user does not have the permission to access an action. You can rescue this error and respond in your customized format using `rescue_from` in your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  include ActionSentinel::Authorization

  rescue_from ActionSentinel::UnauthorizedAction, with: :unauthorized_action

  protected

  def unauthorized_action(error)
    render json: { error_message: error.message }, status: :forbidden
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denisstael/action_sentinel.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
