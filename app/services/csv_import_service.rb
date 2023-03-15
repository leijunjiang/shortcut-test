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

      klass.transaction do
        obj = klass.find_by(reference: param_hash["reference"])
        if obj
          if same_attributes?(obj, non_overridable_attrs) && !same_attributes?(obj, overridable_attrs)
            obj.update(overridable_attrs)
          end
        else
          klass.new(param_hash).save
        end
      end
    end
  end

  def same_attributes?(obj, overridable_attrs)
    overridable_attrs.all? { | attribute, value | obj.send(attribute) == value}
  end
end
