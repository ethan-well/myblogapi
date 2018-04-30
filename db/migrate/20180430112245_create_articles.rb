class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :love_count, null: false, default: 0
      t.integer :collection_count, null: false, default: 0
      t.string :illustration
      t.timestamps
    end
  end
end
