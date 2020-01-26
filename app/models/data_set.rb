class DataSet < ApplicationRecord
  has_one :data_info, as: :data_portion
  has_one :undigested_input

  validates :name, presence: true
  validate :check_keys_info_format
  after_create :create_dynamic_content
  after_find :load_dynamic_content
  before_destroy :destroy_dynamic_content

  def dynamic_content
    "dynamic_content#{self.id}".classify.constantize
  end

  def encode_key(full_name_filed)
    self.keys_info.key full_name_filed
  end

  # letters_key --> Symbol
  def decode_key(letters_key)
    self.keys_info[letters_key]
  end

  protected
    def check_keys_info_format
      if !self.keys_info
        self.errors.add :keys_info, "can't be nil"
      else
        self.keys_info.keys.each do |key|
          string_key = key.to_s
          if string_key.length != 3 or string_key.match(/[^[:alpha:]]/) or string_key != string_key.downcase
            self.errors.add :keys_info, "The keys must have exactly 3 lowercase letters"
            break
          end
        end
      end
    end

    def create_dynamic_content
      class_name = "dynamic_content#{self.id}"
      ActiveRecord::Migration.create_table(class_name) do |t|
        t.jsonb :row
      end
      set_dynamic_content(class_name)
    end

    def load_dynamic_content
      class_name = "dynamic_content#{self.id}"
      # carrega a classe dinamica se não estiver carregada
      set_dynamic_content(class_name) unless ApplicationRecord.subclasses.map(&:name).include? class_name.classify
    end

    def set_dynamic_content(class_name)
      # Cria um model novo (customizado) baseado no id do DataSet
      # em memoria RAM
      # Abaixo é como se fosse um model do ApplicationRecord
      Object.const_set(class_name.classify, Class.new(ApplicationRecord) {
        self.table_name = class_name
        validates :row, presence: true

        ## Não tem como testar as chaves do data_set que gerou esse dynamic_content sem
        ## recarrega-lo do banco. Fazer isso seria carregar o data_set "mãe" TODA vez que fosse
        ## inserido algo nesse dynamic_content.
        ## Solução por enquanto: testar no job de import das bases enriquecidas
        ## OBS: O mesmo vale para testar os tipos da variavel inserido na hash do row
        #
        #validate :check_keys
        #protected
        #  def check_keys
        #  end
      })
    end

    def destroy_dynamic_content
      class_name = "dynamic_content#{self.id}"
      class_name.classify.constantize.destroy_all
      ActiveRecord::Migration.drop_table(class_name)
      ## IMPORTANTE: Não encontrei um jeito de "remover" a definição em memoria do DynamicModel,
      ## a classe permance na listada em ApplicationRecord.subclasses.map(&:name), mesmo com o
      ## comando: Zeitwerk::Loader.eager_load_all
    end
end
