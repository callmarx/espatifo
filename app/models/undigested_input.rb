class UndigestedInput < ApplicationRecord
  ## OBS: Por enquanto não estamos trabalhando com chaves ternários no JSONB (content) do
  ## undigest_input, trabalhando direto com as chaves/colunas fornecidas pelo usuário

  belongs_to :user
  belongs_to :data_set, optional: true

  enum status: [:todo, :doing, :done]

  validate :check_content_and_keys_info_format
  before_save :set_keys_info
  before_save :set_status

  protected
    def check_content_and_keys_info_format
      self.errors.add :content, "can't be nil" unless self.content
      self.errors.add :content, "must be a Array" unless self.content.is_a? Array
      #self.errors.add :keys_info, "can't be nil" unless self.keys_info
      #self.errors.add :keys_info, "must be a Hash" unless self.keys_info.is_a? Hash
    end

    def set_keys_info
      self.keys_info ||= {}
    end

    def set_status
      self.status ||= :todo
    end
end
