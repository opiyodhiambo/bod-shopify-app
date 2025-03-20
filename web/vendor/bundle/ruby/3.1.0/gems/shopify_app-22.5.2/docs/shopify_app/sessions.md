# Sessions

Sessions are used to make contextual API calls for either a shop (offline session) or a user (online session). This gem has ownership of session persistence.

#### Table of contents
- [Sessions](#sessions)
      - [Table of contents](#table-of-contents)
  - [Sessions](#sessions-1)
      - [Types of access tokens (sessions)](#types-of-access-tokens-sessions)
      - [Access token storage (session)](#access-token-storage-session)
        - [Shop (offline) token storage](#shop-offline-token-storage)
        - [User (online) token storage](#user-online-token-storage)
        - [In-memory Session Storage for testing](#in-memory-session-storage-for-testing)
        - [Customizing Session Storage with `ShopifyApp::SessionRepository`](#customizing-session-storage-with-shopifyappsessionrepository)
        - [⚠️  Custom Session Storage Requirements](#️--custom-session-storage-requirements)
        - [Available `ActiveSupport::Concerns` that contains implementation of the above methods](#available-activesupportconcerns-that-contains-implementation-of-the-above-methods)
    - [Loading Sessions](#loading-sessions)
      - [Getting Sessions with Controller Concerns](#getting-sessions-with-controller-concerns)
        - [**Shop Sessions - `EnsureInstalled`**](#shop-sessions---ensureinstalled)
        - [User Sessions - `EnsureHasSession`](#user-sessions---ensurehassession)
      - [Getting sessions from a Shop or User model record - 'with\_shopify\_session'](#getting-sessions-from-a-shop-or-user-model-record---with_shopify_session)
      - [Re-fetching an access token when API returns Unauthorized](#re-fetching-an-access-token-when-api-returns-unauthorized)
  - [Access scopes](#access-scopes)
    - [`ShopifyApp::ShopSessionStorageWithScopes`](#shopifyappshopsessionstoragewithscopes)
    - [`ShopifyApp::UserSessionStorageWithScopes`](#shopifyappusersessionstoragewithscopes)
  - [Migrating from shop-based to user-based token strategy](#migrating-from-shop-based-to-user-based-token-strategy)
  - [Migrating from `ShopifyApi::Auth::SessionStorage` to `ShopifyApp::SessionStorage`](#migrating-from-shopifyapiauthsessionstorage-to-shopifyappsessionstorage)

## Sessions
#### Types of access tokens (sessions)
- **Shop** ([offline access](https://shopify.dev/docs/apps/auth/access-token-types/offline))
  - Access token is linked to the store
  - Meant for long-term access to a store, where no user interaction is involved
  - Ideal for background jobs or maintenance work
- **User** ([online access](https://shopify.dev/docs/apps/auth/access-token-types/online))
  - Access token is linked to an individual user on a store
  - Meant to be used when a user is interacting with your app through the web

#### Access token storage (session)
##### Shop (offline) token storage
⚠️ All apps must have a shop session storage, if you started from the [Ruby App Template](https://github.com/Shopify/shopify-app-template-ruby), it's already configured to have a Shop model by default.

If you don't already have a repository to store the access tokens:

1. Run the following generator to create a shop model to store the access tokens

```sh
rails generate shopify_app:shop_model
```

2. Configure `config/initializers/shopify_app.rb` to enable shop access token persistance:

```ruby
config.shop_session_repository = 'Shop'
```

##### User (online) token storage
If your app has user interactions and would like to control permission based on individual users, you need to configure a User token storage to persist unique tokens for each user.

[Shop (offline) tokens must still be maintained](#shop-offline-token-storage).

1. Run the following generator to create a user model to store the individual based access tokens.

⚠️ If you started from the [Ruby App Template](https://github.com/Shopify/shopify-app-template-ruby), you don't need to run the generator as it's already included in the template. You can skip this step.

```sh
rails generate shopify_app:user_model
```

2. Configure `config/initializers/shopify_app.rb` to enable user access token persistance:

```ruby
config.user_session_repository = 'User'
```

The current Shopify user will be stored in the rails session at `session[:shopify_user]`

You should also enable the [check for session expiry](#expiry-date) so that a new access token can be fetched before being used for an API operation.

##### In-memory Session Storage for testing
The `ShopifyApp` gem includes methods for in-memory storage for both shop and user sessions. In-memory storage is intended to be used in a testing environment, please use a persistent storage for your application.
- [InMemoryShopSessionStore](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/in_memory_shop_session_store.rb)
- [InMemoryUserSessionStore](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/in_memory_user_session_store.rb)

You can configure the `ShopifyApp` configuration to use the in-memory storage method during manual testing:
```ruby
# config/initializers/shopify_app.rb

config.shop_session_repository = ShopifyApp::InMemoryShopSessionStore
config.user_session_repository = ShopifyApp::InMemoryUserSessionStore
```

##### Customizing Session Storage with `ShopifyApp::SessionRepository`

In the rare event that you would like to break Rails convention for storing/retrieving records, the `ShopifyApp::SessionRepository` allows you to define how your sessions are stored and retrieved for shops. The specific repository for `shop` & `user` is configured in the `config/initializers/shopify_app.rb` file and can be set to any object.

```ruby
# config/initializers/shopify_app.rb

config.shop_session_repository = MyCustomShopSessionRepository
config.user_session_repository = MyCustomUserSessionRepository
```

##### ⚠️  Custom Session Storage Requirements

The custom **Shop** repository must implement the following methods:

| Method                                            | Parameters                                 | Return Type               |
|---------------------------------------------------|--------------------------------------------|---------------------------|
| `self.store(auth_session)`                        | `auth_session` (ShopifyAPI::Auth::Session) | -                         |
| `self.retrieve(id)`                               | `id` (String)                              | ShopifyAPI::Auth::Session |
| `self.retrieve_by_shopify_domain(shopify_domain)` | `shopify_domain` (String)                  | ShopifyAPI::Auth::Session |
| `self.destroy_by_shopify_domain(shopify_domain)`  | `shopify_domain` (String)                  | -                         |

The custom **User** repository must implement the following methods:
| Method                                      | Parameters                          | Return Type                  |
|---------------------------------------------|-------------------------------------|------------------------------|
| `self.store(auth_session, user)`            | <li>`auth_session` (ShopifyAPI::Auth::Session)<br><li>`user` (ShopifyAPI::Auth::AssociatedUser) | - |
| `self.retrieve(id)`                         | `id` (String)                       | `ShopifyAPI::Auth::Session`  |
| `self.retrieve_by_shopify_user_id(user_id)` | `user_id` (String)                  | `ShopifyAPI::Auth::Session`  |
| `self.destroy_by_shopify_user_id(user_id)`  | `user_id` (String)                  | -                            |


These methods are already implemented as a part of the `User` and `Shop` models generated from this gem's generator.
- `Shop` model includes the [ShopSessionStorageWithScopes](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/shop_session_storage_with_scopes.rb) concern.
- `User` model includes the [UserSessionStorageWithScopes](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/user_session_storage_with_scopes.rb) concern.

##### Available `ActiveSupport::Concerns` that contains implementation of the above methods
Simply include these concerns if you want to use the implementation, and overwrite methods for custom implementation

- `Shop` storage
  - [ShopSessionStorageWithScopes](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/shop_session_storage_with_scopes.rb)
  - [ShopSessionStorage](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/shop_session_storage.rb)

- `User` storage
  - [UserSessionStorageWithScopes](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/user_session_storage_with_scopes.rb)
  - [UserSessionStorage](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/user_session_storage.rb)

### Loading Sessions
By using the appropriate controller concern, sessions are loaded for you.

#### Getting Sessions with Controller Concerns

⚠️  **Note: These controller concerns cannot both be included in the same controller.**
##### **Shop Sessions - `EnsureInstalled`**
- [EnsureInstalled](https://github.com/Shopify/shopify_app/blob/main/app/controllers/concerns/shopify_app/ensure_installed.rb) controller concern will load a shop session with the `installed_shop_session` helper. If a shop session is not found, meaning the app wasn't installed for this shop, the request will be redirected to be installed.
- This controller concern should NOT be used if you don't need your app to make calls on behalf of a user.
- Example
```ruby
class MyController < ApplicationController
  include ShopifyApp::EnsureInstalled

  def method
    current_session = installed_shop_session # `installed_shop_session` is a helper from `EnsureInstalled`

    client = ShopifyAPI::Clients::Graphql::Admin.new(session: current_session)
    client.query(
      # ...
    )
  end
end
```

##### User Sessions - `EnsureHasSession`
- [EnsureHasSession](https://github.com/Shopify/shopify_app/blob/main/app/controllers/concerns/shopify_app/ensure_has_session.rb) controller concern will load a user session via `current_shopify_session`. As part of loading this session, this concern will also ensure that the user session has the appropriate scopes needed for the application and that it is not expired (when `check_session_expiry_date` is enabled). If the user isn't found or has fewer permitted scopes than are required, they will be prompted to authorize the application.
- This controller concern should be used if you don't need your app to make calls on behalf of a user. With that in mind, there are a few other embedded concerns that are mixed in to ensure that embedding, CSRF, localization, and billing allow the action for the user.
- Example
```ruby
class MyController < ApplicationController
  include ShopifyApp::EnsureHasSession

  def method
    current_session = current_shopify_session # `current_shopify_session` is a helper from `EnsureHasSession`

    client = ShopifyAPI::Clients::Graphql::Admin.new(session: current_session)
    client.query(
      # ...
    )
  end
end
```

#### Getting sessions from a Shop or User model record - 'with_shopify_session'
The [ShopifyApp::SessionStorage#with_shopify_session](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/session_storage.rb#L12)
helper allows you to make API calls within the context of a user or shop, by using that record's access token.

This mixin is already included in ActiveSupport [concerns](#available-activesupportconcerns-that-contains-implementation-of-the-above-methods) from this gem.
If you're using a custom implementation of session storage, you can include the [ShopifyApp::SessionStorage](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/session_storage.rb) concern.

All calls made within the block passed into this helper will be made in that context:

```ruby
# To use shop context for "my_shopify_domain.myshopify.com"
shopify_domain = "my_shopify_domain.myshopify.com"
shop = Shop.find_by(shopify_domain: shopify_domain)
shop.with_shopify_session do
  ShopifyAPI::Product.find(id: product_id)
  # This will call the Shopify API with my_shopify_domain's access token
end

# To use user context for user ID "my_user_id"
user = User.find_by(shopify_user_id: "my_user_id")
user.with_shopify_session do
  ShopifyAPI::Product.find(id: product_id)
  # This will call the Shopify API with my_user_id's access token
end
```

#### Re-fetching an access token when API returns Unauthorized

When using `ShopifyApp::EnsureHasSession` and the `new_embedded_auth_strategy` configuration, any **unhandled** Unauthorized `ShopifyAPI::Errors::HttpResponseError` will cause the app to perform token exchange to fetch a new access token from Shopify and the action to be executed again. This will update and store the new access token to the current session instance.

```ruby
class MyController < ApplicationController
  include ShopifyApp::EnsureHasSession

  def index
    client = ShopifyAPI::Clients::Graphql::Admin.new(session: current_shopify_session)

    # If this call raises an Unauthorized error from Shopify, EnsureHasSession
    # will execute the action again after performing token exchange.
    # It will store and use the newly retrieved access token for this and any subsequent calls.
    client.query(options)
  end
end
```

If the error is being rescued in the action, it's still possible to make use of `with_token_refetch` provided by `EnsureHasSession` so that a new access token is fetched and the code is executed again with it. This will also update the session parameter with the new attributes.
This block should be used to wrap the code that makes API queries, so your business logic won't be retried.

```ruby
class MyController < ApplicationController
  include ShopifyApp::EnsureHasSession

  def index
    # Your app's business logic
    with_token_refetch(current_shopify_session, shopify_id_token) do
      # Unauthorized errors raised within this block will initiate token exchange.
      # `with_token_refetch` will store the new access token and use it
      # to execute this block again.
      # Any subsequent calls using the same session instance will have the new token.
      client = ShopifyAPI::Clients::Graphql::Admin.new(session: current_shopify_session)
      client.query(options)
    end
    # Your app's business logic continues
  rescue => error
    # app's specific error handling
  end
end
```

It's also possible to use `with_token_refetch` on classes other than the controller by including the `ShopifyApp::AdminAPI::WithTokenRefetch` module and passing in the session along with the current request's `shopify_id_token`, which is provided by `ShopifyApp::EnsureHasSession`. This will also update the session parameter with the new attributes.

```ruby
# my_controller.rb
class MyController < ApplicationController
  include ShopifyApp::EnsureHasSession

  def index
    # shopify_id_token is a method provided by EnsureHasSession
    MyClass.new.do_things(current_shopify_session, shopify_id_token)
  end
end

# my_class.rb
class MyClass
  include ShopifyApp::AdminAPI::WithTokenRefetch

  def do_things(session, shopify_id_token)
    with_token_refetch(session, shopify_id_token) do
      # Unauthorized errors raised within this block will initiate token exchange.
      # `with_token_refetch` will store the new access token and use it
      # to execute this block again.
      # Any subsequent calls using the same session instance will have the new token.
      client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
      client.query(options)
    end
  rescue => error
    # app's specific error handling
  end
end
```

If the retried block raises an `Unauthorized` error again, `with_token_refetch` will delete the current `session` from the database and raise the error again.

```ruby
class MyController < ApplicationController
  include ShopifyApp::EnsureHasSession

  def index
    client = ShopifyAPI::Clients::Graphql::Admin.new(session: current_shopify_session)
    with_token_refetch(current_shopify_session, shopify_id_token) do
      # When this call raises Unauthorized a second time during retry,
      # the `session` will be deleted from the database and the error raised
      client.query(options)
    end
  rescue => error
    # The Unauthorized error will reach this rescue
  end
end
```

## Access scopes
If you want to customize how access scopes are stored for shops and users, you can implement the `access_scopes` getters and setters in the models that include `ShopifyApp::ShopSessionStorageWithScopes` and `ShopifyApp::UserSessionStorageWithScopes` as shown:

### `ShopifyApp::ShopSessionStorageWithScopes`
```ruby
class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorageWithScopes

  def access_scopes=(scopes)
    # Store access scopes
  end
  def access_scopes
    # Find access scopes
  end
end
```

### `ShopifyApp::UserSessionStorageWithScopes`
```ruby
class User < ActiveRecord::Base
  include ShopifyApp::UserSessionStorageWithScopes

  def access_scopes=(scopes)
    # Store access scopes
  end
  def access_scopes
    # Find access scopes
  end
end
```

## Expiry date
When the configuration flag `check_session_expiry_date` is set to true, the user session expiry date will be checked to trigger a re-auth and get a fresh user token when it is expired. This requires the `ShopifyAPI::Auth::Session` `expires` attribute to be stored. When the `User` model includes the `UserSessionStorageWithScopes` concern, a DB migration can be generated with `rails generate shopify_app:user_model --skip` to add the `expires_at` attribute to the model.

## Migrating from shop-based to user-based token strategy

1. Run the `user_model` generator as [mentioned above](#user-online-token-storage).
  - The generator will ask whether you want to migrate the User model to include `access_scopes` and `expires_at` columns. `expires_at` field is useful for detecting when the user session has expired and trigger a re-auth before an operation. It can reduce
   API failures for invalid access tokens. Configure the [expiry date check](#expiry-date) to complete this feature.
2. Ensure that both your `Shop` model and `User` model includes the [necessary concerns](#available-activesupportconcerns-that-contains-implementation-of-the-above-methods)
3. Update the configuration file to use the new session storage.

```ruby
# config/initializers/shopify_app.rb

config.shop_session_repository = {YOUR_SHOP_MODEL_CLASS}
config.user_session_repository = {YOUR_USER_MODEL_CLASS}
```

## Migrating from `ShopifyApi::Auth::SessionStorage` to `ShopifyApp::SessionStorage`
- Support for using `ShopifyApi::Auth::SessionStorage` was removed from ShopifyApi [version 13.0.0](https://github.com/Shopify/shopify-api-ruby/blob/main/CHANGELOG.md#1300)
- Sessions storage are now handled with [ShopifyApp::SessionRepository](https://github.com/Shopify/shopify_app/blob/main/lib/shopify_app/session/session_repository.rb)
- To migrate and specify your shop or user session storage method:
  1. Remove `session_storage` configuration from `config/initializers/shopify_app.rb`
  2. Follow ["Access Token Storage" instructions](#access-token-storage-session) to specify the storage repository for shop and user sessions.
     - [Customizing session storage](#customizing-session-storage-with-shopifyappsessionrepository)
