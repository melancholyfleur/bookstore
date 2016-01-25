class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.integer :publisher_id
      t.integer :author_id

      t.timestamps null: false
    end
    add_index :books, :publisher_id
    add_index :books, :author_id
  end
end
