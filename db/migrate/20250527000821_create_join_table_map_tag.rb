class CreateJoinTableMapTag < ActiveRecord::Migration[8.0]
  def change
    create_join_table :maps, :tags do |t|
      # composite index speeds up lookups in both directions
      t.index [:map_id, :tag_id], unique: true
      t.index [:tag_id, :map_id], unique: true
    end
  end
end
