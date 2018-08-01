module StructuredMenus::Adapters
  class DashboardAdapter
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::OutputSafetyHelper

    # Accepted options:
    #
    # :if - only include this menu item if the provided block returns true when passed the current user (if not present, item is always included)
    # :width - the number of cards to include in one row of the menu (max 12, default 4)
    # :class - the CSS class to apply to each card's wrapper <div> (default dashboard-menu-card)
    #
    # You still need to provide your own styles for .dashboard-menu-card.
    def self.show(menu, user, **options)
      inst = new
      width = options[:width] || 4
      cards = menu.map do |i|
        next unless !i['if'] || instance_eval(i['if']).call(user)

        cls = options[:class] || 'dashboard-menu-card'
        inst.raw("<div class=\"#{cls}\">#{inst.link_to inst.raw("<i class=\"fas fa-#{i['icon']}\"></i> #{i['name']}"), i['link']}</div>")
      end.compact

      inst.raw(cards.in_groups_of(width).map(&:compact).map do |g|
        '<div class="row">' + g.map { |c| "<div class=\"col-md-#{12 / width}\">#{c}</div>" }.join("\n") + '</div>'
      end.join("\n"))
    end
  end
end