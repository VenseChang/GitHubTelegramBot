class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.boolean :is_bot
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :language_code
      t.string :github_token

      t.timestamps
    end
  end
end
