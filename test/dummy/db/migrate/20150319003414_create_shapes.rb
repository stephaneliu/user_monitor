class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.string :name
      t.integer :created_by
      t.integer :updated_by

      t.timestamps null: false
    end
  end
end
