class AddSlugToUser < ActiveRecord::Migration[5.0]
  class MigrateUser < ActiveRecord::Base
    self.table_name = :users

    def set_slug
      return if name.nil?
      self.slug = name.gsub(/\s/, '_').gsub(/[^\w+]/, '').downcase
    end
  end

  def up
    add_column :users, :slug, :string

    MigrateUser.all.each do |user|
      user.set_slug
      user.save
    end
  end

  def down
    remove_column :users, :slug, :string
  end
end
