class ChangePeopleToBeIntegerInReference < ActiveRecord::Migration[7.0]
  def up
    change_column :people, :reference, :integer
  end

  def down
    change_column :people, :reference, :string
  end
end
