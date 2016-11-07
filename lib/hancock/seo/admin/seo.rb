module Hancock::Seo
  module Admin
    module Seo
      def self.config(fields = {})
        Proc.new {
          navigation_label 'SEO'
          label I18n.t('hancock.seo.seo')
          field :seoable do
            read_only true
          end
          field :h1, :string do
            searchable true
          end
          field :title, :string do
            searchable true
          end
          field :keywords, :text do
            searchable true
          end
          field :description, :text do
            searchable true
          end
          field :robots, :string

          field :og_title, :string do
            searchable true
          end

          if Hancock::Seo.config.gallery_support
            field :og_image, :hancock_image
          end

          Hancock::RailsAdminGroupPatch::hancock_cms_group(self, fields)

          if block_given?
            yield self
          end
        }
      end
    end
  end
end
