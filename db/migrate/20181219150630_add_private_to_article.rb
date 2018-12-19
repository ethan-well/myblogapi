class AddPrivateToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :private, :boolean, null: false, default: false
  end
end
