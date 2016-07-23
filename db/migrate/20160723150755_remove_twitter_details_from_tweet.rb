class RemoveTwitterDetailsFromTweet < ActiveRecord::Migration[5.0]
  def change
    remove_column :tweets, :screen_name, :string
    remove_column :tweets, :name, :string
  end
end
