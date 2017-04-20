class CreateListSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :list_subscribers do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :list, type: :uuid, index: true, foreign_key: true
      t.timestamps
    end

  end
end
