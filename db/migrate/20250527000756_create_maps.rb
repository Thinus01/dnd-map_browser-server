class CreateMaps < ActiveRecord::Migration[8.0]
  def change
    create_table :maps do |t|
      t.string  :link,      null: false
      t.boolean :favourites, default: false, null: false

      t.timestamps
    end
  end
end
