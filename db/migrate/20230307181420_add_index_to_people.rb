class AddIndexToPeople < ActiveRecord::Migration[7.0]
  def change
    add_index :people, :reference
  end
end
