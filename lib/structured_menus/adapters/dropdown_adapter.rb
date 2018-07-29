module StructuredMenus::Adapters
  class DropdownAdapter
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::OutputSafetyHelper

    # Accepted options:
    #
    # :if - only include this menu item if the provided block returns true when passed the current user (if not present, item is always included)
    # :include_icon - if true, include a FontAwesome icon (no fa- prefix) as specified by the `icon` property in the menu's YAML (default false)
    # :include_ul - if true, wrap the dropdown <li> list in a <ul> (default true)
    #
    # With :include_icon, you still need to include FontAwesome yourself.
    # With :include_ul, you still need to add the dropdown's trigger yourself.
    def self.show(menu, user, **options)
      inst = new
      items = menu.map do |i|
        next unless !i['if'] || instance_eval(i['if']).call(user)

        if !options[:include_icon]
          inst.raw("<li>#{inst.link_to i['name'], i['link']}</li>")
        else
          inst.raw("<li>#{inst.link_to inst.raw("<i class=\"fas fa-#{i['icon']}\"></i> #{i['name']}"), i['link']}</li>")
        end
      end.compact

      if options[:include_ul] || options[:include_ul].nil?
        inst.raw('<ul class="dropdown-menu">' + items.join("\n") + '</ul>')
      else
        inst.raw(items.join("\n"))
      end
    end
  end
end