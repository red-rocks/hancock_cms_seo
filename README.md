# HancockCmsSeo

### Remaded from [EnjoyCMSSeo](https://github.com/enjoycreative/enjoy_cms_seo)

SEO and sitemap fields for [HancockCMS](https://github.com/red-rocks/hancock_cms).
Add Seo support to HancockCMS plugins by default and other objects in two lines.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hancock_cms_seo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hancock_cms_seo

## Usage

### Mongoid

Add this in your model for attributes
```ruby
include Hancock::Seo::Seoable
include Hancock::Seo::SitemapDataField
```

and this for rails_admin config
```ruby
group :seo do
  active false
  field :seo
end
group :sitemap_data do
  active false
  field :sitemap_data
end
```

Also you can generate and then edit config/initializers/hancock_seo.rb

    $ rails g hancock:seo:config

SEO fields (h1, title, keywords, description, og_title, og_image, robots) and sitemap_data fields(sitemap_show, sitemap_lastmod, sitemap_changefreq, sitemap_priority) are delegated to your model.

#### Sitemap

Also you can use [SitemapGenerator](https://github.com/kjvarga/sitemap_generator) for sitemap.

#### Google Analitics and Yandex Metrika

We have helper methods for this. Usage
```ruby
hancock_ym_counter_tag('counter_id')
```
or
```ruby
hancock_ga_counter_tag('counter_id')
```
or
```ruby
render_hancock_counters(ym_counter_id: 'counter_id1', ga_counter_id: 'counter_id2')
```
[More](https://github.com/red-rocks/hancock_cms_seo/blob/master/app/helpers/hancock/seo/seo_helper.rb)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/red-rocks/hancock_cms_seo.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
