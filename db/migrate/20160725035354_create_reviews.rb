class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.string :artist
      t.string :album
      t.references :user, foreign_key: true
      t.integer :rating
      t.string :genre
      t.string :listen_url
      t.string :album_source_id
      t.text :text
      t.date :reviewed_on

      t.timestamps
    end
  end
end
