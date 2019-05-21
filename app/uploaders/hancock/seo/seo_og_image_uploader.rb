if defined?(HancockShrine)
  class Hancock::Seo::SeoOgImageUploader < HancockUploader
    
    plugin :versions, fallbacks: {
      main: :original,
      standard: :original,
      thumb: :main
    }

    # plugin :processing
    def hancock_processing(io, context)
      original, versions = get_data_from(io, context) do |original, versions|
        begin      
          crop_params = crop_params(context[:record])
          pipeline = get_pipeline(original)
          return versions if pipeline.blank?
          
          versions[:compressed] = pipeline.convert!(nil)
          pipeline = pipeline.crop(*crop_params) if crop_params
          versions[:main]     ||= pipeline.resize_to_limit!(810, 360, {sharpen: false, size: :down})
          versions[:standard] ||= pipeline.resize_to_limit!(810, 360, {sharpen: false, size: :down})
          versions[:thumb]    ||= pipeline.resize_to_limit!(270, 120, {sharpen: false, size: :down})
        rescue
        end
        versions
      end
      versions.compact
    end

  end
end