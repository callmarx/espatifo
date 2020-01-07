### Versão antiga de 'custom log' que necessitava de initializer, alterado por
### conta das melhoris do Rails 6
#class DataListPresetLog
#  LogFile = Rails.root.join('log', 'DataListPreset.log')
#  class << self
#  cattr_accessor :logger
#    delegate :debug, :info, :warn, :error, :fatal, :to => :logger
#  end
#end
#
#
### Conteudo do arquivo que ficava em
### config/initializers/data_list_preset_log.rb
#if Rails.env.development?
#  DataListPresetLog.logger = Logger.new(DataListPresetLog::LogFile)
#  DataListPresetLog.logger.level = 'info' # could be debug, info, warn, error or fatal
#end


## Nova versão sem initializer
module CustomLogs::Preset
  def self.debug(message=nil)
    return unless Rails.env.development? and message.present?
    @logger ||= Logger.new(File.join(Rails.root, 'log', 'PresetLog.log'))
    @logger.debug(message)
  end
end
