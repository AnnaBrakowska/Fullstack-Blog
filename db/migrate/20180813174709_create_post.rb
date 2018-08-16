class CreatePost < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :text
      t.string :image
    end
  end
end
