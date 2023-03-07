module CsvImportComponent
  extend ActiveSupport::Concern

  # TODO use Sidekiq Worker to perform parallelism computing
  # by using Sidekiq's multi-thread and multi-process mecanism
  def import(csv_path = default_csv_path)
    CsvImportService.new(self.to_s, csv_path, self.name.constantize::NON_OVERRIDABLE_ATTRIBUTES).perform
  end

  def default_csv_path
    name = self.to_s.pluralize
    "#{Rails.root}/db/data/#{name}.csv"
  end
end
