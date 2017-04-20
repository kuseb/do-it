class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists, id: :uuid do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.string :color
      t.boolean :is_public
      t.timestamps
    end
  end
end
