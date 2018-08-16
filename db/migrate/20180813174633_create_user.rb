class CreateUser < ActiveRecord::Migration[5.2]
  def change 
    create_table :users do |t|
    t.string :user_name
    t.string :first_name
    t.string :last_name
    t.string :email
    t.string :password
    t.date :birthday
    t.string :image_url
    end
  end
end


