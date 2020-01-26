class UndigestedInput < ApplicationRecord
  belongs_to :user
  belongs_to :data_set

  validate :check_content_and_columns_format

  protected
    def check_content_and_columns_format
      self.errors.add :content, "can't be nil" unless self.content
      self.errors.add :content, "must be a Array" unless self.content.is_a? Array
      self.errors.add :columns, "can't be nil" unless self.columns
      self.errors.add :columns, "must be a Hash" unless self.columns.is_a? Hash
    end
end
