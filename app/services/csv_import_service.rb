require 'csv'
class CsvImportService
  attr_accessor :klass, :csv_path, :non_overridable_attributes

  def initialize(_klass, csv_path, non_overridable_attributes)
    @csv_path = csv_path
    @klass = _klass.constantize
    @non_overridable_attributes = non_overridable_attributes
  end

  def perform
    CSV.foreach(csv_path, headers: true) do |row|
      param_hash = row.to_h
      overridable_attrs     = param_hash.except(*non_overridable_attributes+["reference"])
      non_overridable_attrs = param_hash.slice(*non_overridable_attributes)
      klass.find_or_initialize_by(reference: param_hash["reference"]).tap do |obj|
        overridable_attrs.each do |key, value|
          obj.write_attribute(key, value)
        end
        non_overridable_attrs.each do |key, value|
          obj.write_attribute(key, obj.send(key) || value)
        end
        obj.save!
      end
    end
  end
end
