class CreateGithubs < ActiveRecord::Migration[5.2]
  def change
    create_table :githubs do |t|
      t.string :login
      t.string :node_id
      t.string :avatar_url
      t.string :gravatar_id
      t.string :html_url
      t.boolean :site_admin
      t.string :name
      t.string :company
      t.string :blog
      t.string :location
      t.string :email
      t.string :hireable
      t.string :bio
      t.integer :public_repos
      t.integer :public_gists
      t.integer :followers
      t.integer :following
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
