class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.string :email
      t.text :text
      t.boolean :edited
      t.boolean :deleted

      t.timestamps null: false
    end
  end
end
