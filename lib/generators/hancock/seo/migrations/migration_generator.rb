require 'rails/generators'
require 'rails/generators/active_record'

module Hancock::Seo
  class MigrationGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    desc 'Hancock SEO migration generator'
    def migration
      if Hancock.active_record?
        %w(seos).each do |table_name|
          migration_template "migration_#{table_name}.rb", "db/migrate/hancock_create_#{table_name}.rb"
        end
      end
    end
  end
end
