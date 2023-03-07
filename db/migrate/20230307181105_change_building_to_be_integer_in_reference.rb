class ChangeBuildingToBeIntegerInReference < ActiveRecord::Migration[7.0]
  def up
    change_column :buildings, :reference, :integer
  end

  def down
    change_column :buildings, :reference, :string
  end
end
