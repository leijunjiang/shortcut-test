# == Schema Information
#
# Table name: people
#
#  id                  :integer          not null, primary key
#  address             :string
#  email               :string
#  firstname           :string
#  home_phone_number   :string
#  lastname            :string
#  mobile_phone_number :string
#  reference           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_people_on_reference  (reference)
#
require "test_helper"

Person.class_eval do
  def equal_attributes?(other)
    attrs = self.attributes.except(*%w[id created_at updated_at]).keys

    return false if attrs.detect {|attr| self.send(attr) != other.send(attr)}

    true
  end
end

class PersonTest < ActiveSupport::TestCase

  test "default person count == 2" do
    assert Person.count == 2
  end

  test "#Person.import with success" do
    Person.import
    assert Person.count == 4
  end

  test "idempotency import and update when not_overridable = same values and overridable = same values" do
    Person.import
    last_one = Person.last
    Person.import
    assert last_one.equal_attributes?(Person.last)
    assert Person.count == 4
  end

  test "import and update when not_overridable = same values and overridable = diffent values" do
    Person.import
    last_person =  Person.last
    new_firstname = "XXXXXXX"
    last_person.update(firstname: new_firstname)
    last_person_reference = last_person.reference
    Person.import
    assert Person.find_by_reference(last_person_reference).firstname != new_firstname
  end

  test "do not import and update when not_overridable = diffent values and overridable = same values" do
    Person.import
    attr = Person::NON_OVERRIDABLE_ATTRIBUTES.first
    last_person =  Person.last
    default_value =  last_person.send(attr)
    modified_value = default_value + " +++modified+++"
    last_person.update(attr => modified_value)
    last_person_reference = last_person.reference
    Person.import
    assert Person.find_by_reference(last_person_reference).send(attr) == modified_value
  end

  test "do not import and update when not_overridable = diffent values and overridable = diffent values" do
    Person.import
    attr = Person::NON_OVERRIDABLE_ATTRIBUTES.first
    last_person =  Person.last
    new_firstname = "XXXXXXX"
    last_person.update(firstname: new_firstname)
    default_value =  last_person.send(attr)
    modified_value = default_value + " +++modified+++"
    last_person.update(attr => modified_value)
    last_person_reference = last_person.reference
    Person.import
    assert Person.find_by_reference(last_person_reference).send(attr) == modified_value
    assert Person.find_by_reference(last_person_reference).firstname == new_firstname
  end
end
