class CreateShapeWithoutMonitors < ActiveRecord::Migration
  def change
    create_table :shape_without_monitors do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
