class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :list, type: :uuid, index: true, foreign_key: true
      t.boolean :is_done
      t.string :content
      t.integer :importance
      t.datetime :deadline, null: true
      t.timestamps
    end
  end
end
