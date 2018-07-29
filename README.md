# `structured_menus`
An easy way to create flexible menus for Rails apps.

## Installation
Add this line to your Gemfile and run `bundle install`:

    gem 'structured_menus'
    
Next, create a configuration file in `config/initializers`, probably called `structured_menus.rb` because convention, and add the following to it:

```ruby
StructuredMenus::Configurator.configure do |config|
  # You don't have to add anything here, if you like the defaults, but you still need to call `configure`.
end
```

## Quick Start
Once you've done the above, create `app/menus/menu.yml`, and add the following to it:

```yaml
- name: FAQ
  icon: question
  link: /faq
```

In the view in which you want to display the menu, add this code:

```erb
<%= Rails.menus.show :menu, :dashboard, current_user %>
``` 

You can substitute `:dashboard` for `:dropdown` if you want a Bootstrap dropdown menu instead; if you don't have a `current_user` method, use `nil`.

Continue reading for more detailed usage options.
    
## Usage
StructuredMenus enables you to create menus for your app by writing YAML files in (by default) `app/menus`. Each file is a menu; each item in the file
becomes an item on your menu, displayed according to the adapter (more on that later) and options you specify. Such a file might look like this:

```yaml
- name: Admin
  icon: cogs
  link: /admin
  if: 'lambda { |u| u&.has_role?(:admin) }'

- name: CRM
  icon: users
  link: /crm

- name: Orders
  icon: money-bill-alt
  link: /orders
```

Save that as `mymenu.yml`, and you'll be able to call `Rails.menus.show :mymenu, :dashboard, current_user` to pop it up anywhere in your app.

### Adapters
Adapters are the bits that control how the menu is actually displayed. There are two included by default: `:dashboard` and `:dropdown`. Both are 
designed to work with Bootstrap and FontAwesome (yes, I'm opinionated). Each adapter supports different options - see the definitions in 
`lib/structured_menus/adapters` for details on what they are.

 - **Dashboard** is designed to be a full-screen main menu type thing, probably for apps with lots of navigation. The example menu YAML shown above
   looks like this when shown (some custom CSS - the topbar is not part of the menu):
   
   [![](https://i.stack.imgur.com/n0sbQ.png)](https://i.stack.imgur.com/n0sbQ.png)
   
   Use `:dashboard` in your call to `Rails.menus.show` to get this adapter.
   
 - **Dropdown** is, well, a Bootstrap dropdown menu. It doesn't include icons by default, but you can make it do so if you want them. The same YAML
   looks like this with the dropdown adapter:
   
   [![](https://i.stack.imgur.com/rc1Ww.png)](https://i.stack.imgur.com/rc1Ww.png)
   
   Use `:dropdown` in your call to `Rails.menus.show` to get this adapter.
   
#### Custom adapters
If those two don't suit your needs, you can write your own custom adapter. Essentially, this needs to emulate one of the two stock adapters, in that:

 - It must respond to `#show`
 - Calls to `#show` must respond with the string of raw HTML that you want to render.
 
For reference, here's what the dashboard adapter looks like:

```ruby
module StructuredMenus::Adapters
  class DashboardAdapter
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::OutputSafetyHelper
    
    def self.show(menu, user, **options)
      inst = new
      width = options[:width] || 4
      cards = menu.map do |i|
        next unless !i['if'] || instance_eval(i['if']).call(user)

        cls = options[:class] || 'dashboard-menu-card'
        inst.raw("<div class=\"#{cls}\">#{inst.link_to inst.raw("<i class=\"fas fa-#{i['icon']}\"></i> #{i['name']}"), i['link']}</div>")
      end.compact

      inst.raw(cards.in_groups_of(12 / width).map(&:compact).map do |g|
        '<div class="row">' + g.map { |c| "<div class=\"col-md-#{12 / width}\">#{c}</div>" }.join("\n") + '</div>'
      end.join("\n"))
    end
  end
end
```

The parameters that will be passed to `#show` are as follows:

 - `menu` - a parsed YAML file, in the form of an array. Each element is a hash representing a single menu item as specified in the file.
 - `user` is the value passed to `Rails.menus.show`, which should be a reference to the current user. This can be `nil`.
 - `**options` is a hash of additional options - it's up to you what you want to support. Look at the adapter files in `lib/structured_menus/adapters`
   to see the options that the stock adapters support.

## Contributions
Welcome. Ping me a PR. For large changes you should probably open an issue first to discuss.

## License
Available under the terms of the MIT license.