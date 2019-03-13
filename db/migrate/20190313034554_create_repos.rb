class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos do |t|
      t.string :node_id
      t.string :name
      t.string :full_name
      t.string :html_url
      t.string :description
      t.references :github, foreign_key: true

      t.timestamps
    end
  end
end
