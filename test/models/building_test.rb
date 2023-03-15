# == Schema Information
#
# Table name: buildings
#
#  id           :integer          not null, primary key
#  address      :string
#  city         :string
#  country      :string
#  manager_name :string
#  reference    :integer
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_buildings_on_reference  (reference)
#
require "test_helper"

Building.class_eval do
  def equal_attributes?(other)
    attrs = self.attributes.except(*%w[id created_at updated_at]).keys

    return false if attrs.detect {|attr| self.send(attr) != other.send(attr)}

    true
  end
end

class BuildingTest < ActiveSupport::TestCase

  test "default building count == 2" do
    assert Building.count == 2
  end

  test "#Building.import with success" do
    Building.import
    assert Building.count == 4
  end

  test "idempotency import and update when not_overridable = same values and overridable = same values" do
    Building.import
    last_one = Building.last
    Building.import
    assert last_one.equal_attributes?(Building.last)
    assert Building.count == 4
  end

  test "import and update when not_overridable = same values and overridable = diffent values" do
    Building.import
    last_building =  Building.last
    new_zip_code = "99999"
    last_building.update(zip_code: "99999")
    last_building_reference = last_building.reference
    Building.import
    assert Building.find_by_reference(last_building_reference).zip_code != new_zip_code
  end

  test "do not import and update when  not_overridable = diffent values and overridable = same values" do
    Building.import
    attr = Building::NON_OVERRIDABLE_ATTRIBUTES.first
    last_building =  Building.last
    default_value =  last_building.send(attr)
    modified_value = default_value + " +++modified+++"
    last_building.update(attr => modified_value)
    last_building_reference = last_building.reference
    Building.import
    assert Building.find_by_reference(last_building_reference).send(attr) == modified_value
    assert last_building.equal_attributes?(Building.last)
  end

  test "do not import and update when not_overridable = diffent values and overridable = diffent values" do
    Building.import
    attr = Building::NON_OVERRIDABLE_ATTRIBUTES.first
    last_building =  Building.last
    default_value =  last_building.send(attr)
    modified_value = default_value + " +++modified+++"
    last_building.update(attr => modified_value)
    new_zip_code = "99999"
    last_building.update(zip_code: "99999")
    last_building_reference = last_building.reference
    Building.import
    assert Building.find_by_reference(last_building_reference).send(attr) == modified_value
    assert Building.find_by_reference(last_building_reference).zip_code == new_zip_code
  end
end
