class CreateTagged < ActiveRecord::Migration[5.2]
  def change
    create_table :taggeds do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :article, index: true
      t.timestamps
    end
  end
end
