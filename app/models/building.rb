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
class Building < ApplicationRecord
  extend CsvImportComponent
  validates :reference, presence: true
  validates :reference, uniqueness: true

  NON_OVERRIDABLE_ATTRIBUTES = %w[manager_name]
end
