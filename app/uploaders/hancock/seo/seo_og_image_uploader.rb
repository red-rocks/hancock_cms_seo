if defined?(HancockShrine)
  # class Hancock::Seo::SeoOgImageUploader < HancockUploader
  class Hancock::Seo::SeoOgImageUploader < HancockShrine::Uploader
    
    plugin :versions, fallbacks: {
      main: :original,
      standard: :original,
      thumb: :main
    }

  end
end