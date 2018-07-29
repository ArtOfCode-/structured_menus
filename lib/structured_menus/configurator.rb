require_relative 'dispatcher'
require_relative 'adapters/dashboard_adapter'
require_relative 'adapters/dropdown_adapter'

module StructuredMenus
  @config = nil

  def self.config
    @config
  end

  def self.config=(val)
    @config = val
  end

  class Configurator
    attr_accessor :menus_directory, :adapters

    def initialize
      @menus_directory = Rails.root.join('app/menus')
      @adapters = [Adapters::DashboardAdapter, Adapters::DropdownAdapter]
    end

    def self.configure
      inst = new
      yield inst
      StructuredMenus.config = inst

      Rails.module_eval do
        @menus = StructuredMenus::Dispatcher.new

        def self.menus
          @menus
        end
      end
    end
  end
end