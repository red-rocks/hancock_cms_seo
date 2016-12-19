require 'rails_admin/config/actions'
require 'rails_admin/config/model'

require "rails_admin_toggleable"

module RailsAdmin
  module Config
    module Actions
      class HancockSitemapGenerate < Base
        RailsAdmin::Config::Actions.register(self)

        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end

        register_instance_option :collection? do
          true
        end

        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          false
        end

        register_instance_option :route_fragment do
          'hancock_sitemap_generate'
        end

        register_instance_option :controller do
          Proc.new do |klass|
            # @config = ::HancockCacheGlobalClear::Configuration.new @abstract_model
            if request.get?
              render action: @action.template_name

            elsif request.post?
              #https://github.com/red-rocks/rails_admin_sitemap
              error = nil

              begin

                case RailsAdminSitemap.configuration.generator

                  #https://github.com/kjvarga/sitemap_generator
                  when :sitemap_generator then
                    ::SitemapGenerator::Interpreter.run(:config_file => RailsAdminSitemap.configuration.config_file)

                  #https://github.com/lassebunk/dynamic_sitemaps
                  when :dynamic_sitemaps
                    require 'dynamic_sitemaps'
                    DynamicSitemaps.configure do |config|
                      config.path             = RailsAdminSitemap.configuration.dynamic_sitemaps_conf[:path]
                      config.folder           = RailsAdminSitemap.configuration.dynamic_sitemaps_conf[:folder]
                      config.index_file_name  = RailsAdminSitemap.configuration.dynamic_sitemaps_conf[:index_file_name]

                      config.config_path      = RailsAdminSitemap.configuration.config_file
                    end
                    DynamicSitemaps.generate_sitemap

                  #https://github.com/viseztrance/rails-sitemap
                  when :rails_sitemap
                    require "sitemap"
                    require RailsAdminSitemap.configuration.config_file
                    path = RailsAdminSitemap.configuration.output_file
                    ::Sitemap::Generator.instance.build!
                    ::Sitemap::Generator.instance.save path

                  else
                    error = t("admin.actions.sitemap.incorrect_generator")
                end

              rescue Exception => ex
                error = ex.message
                error ||= t("admin.actions.sitemap.unknown_error")
              end

              if error.blank?
                flash[:notice]  = t("admin.actions.sitemap.done")
              else
                flash[:error]   = error
              end

              # redirect_to dashboard_path
              redirect_to index_path(model_name: @abstract_model)
            end
          end
        end

        register_instance_option :link_icon do
          'icon-refresh'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

      end
    end
  end
end
