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
class Person < ApplicationRecord
  extend CsvImportComponent
  validates :reference, presence: true
  validates :reference, uniqueness: true

  NON_OVERRIDABLE_ATTRIBUTES = %w[email address mobile_phone_number home_phone_number]
end
