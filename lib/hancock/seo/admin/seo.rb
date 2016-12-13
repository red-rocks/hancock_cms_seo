module Hancock::Seo
  module Admin
    module Seo
      def self.config(fields = {})
        Proc.new {
          navigation_label 'SEO'
          label I18n.t('hancock.seo.seo')
          field :seoable do
            read_only true
            pretty_value do
              v = bindings[:view]
              [value].flatten.select(&:present?).collect do |associated|
                amc = polymorphic? ? RailsAdmin.config(associated) : associated_model_config # perf optimization for non-polymorphic associations
                am = amc.abstract_model
                wording = associated.send(amc.object_label_method)
                wording = "#{wording} (#{am.model.model_name.human})"
                can_see = !am.embedded? && (show_action = v.action(:show, am, associated))
                can_see ? v.link_to(wording, v.url_for(action: show_action.action_name, model_name: am.to_param, id: associated.id), class: 'pjax') : ERB::Util.html_escape(wording)
              end.to_sentence.html_safe
            end
          end
          field :h1, :string do
            searchable true
          end
          field :title, :string do
            searchable true
          end
          field :author, :string do
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
