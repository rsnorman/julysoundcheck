class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string   :name
      t.string   :twitter_id
      t.string   :twitter_name
      t.string   :twitter_screen_name
      t.boolean  :admin,                default: false
      t.datetime :last_sign_in
      t.integer  :sign_ins,             default: 0

      t.timestamps
    end
  end
end
