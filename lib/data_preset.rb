module DataPreset
  def self.read(preset_params)
    return [true, nil] unless preset_params
    CustomLogs::Preset.debug "preset_params recebido: #{JSON.pretty_generate(preset_params)}"
    logic = preset_params.delete :logic # ANTENÇÃO: Altera o valor do argumento!
    #logic = preset_params[:logic]
    #preset_params = preset_params.except(:logic)

    ## Testando preenchimento correto de preset_params
    return [false,{
      error: "No 'logic' key!",
      message:"Read the API documentation"
    }] unless logic.is_a? String

    ## verifico se logic tem apenas os caracters: '()expandor[0-9] '
    return [false, {
      error: "Wrong 'logic' key!",
      message: "Character not allowed in 'logic' key"
    }] if logic.match(/[^()expandor[0-9] ]/)

    ## verifico quantide correta de abre e fecha parenteses
    return [false, {
      error: "Wrong 'logic' key!",
      message:"Number of breckets not equal."
    }] if (logic.scan(/(?=#{'\('})/).count != logic.scan(/(?=#{'\)'})/).count)

    logic_exp_array = logic.scan(/exp[0-9]+/)
    ## Verifico se minhas keys existem em logic
    preset_params.keys.each do |k|
      return [false, {
        error: "Wrong params!",
        message: "Key '#{k}' not included in 'logic'"
      }] unless logic_exp_array.include? k.to_s
    end

    ## verifico se quantidade de exp em logic e no resto de preset_params é igual
    return [false, {
      error: "Wrong 'logic' key",
      message:"Number of 'exp' not equal."
    }] if preset_params.count != logic_exp_array.count

    query_array = preset_params.map do |exp, subhash|
      ## Se subhash não é Hash retorna erro
      unless subhash.is_a? Hash
        return [false, {
          error: "No field defined",
          message: "Each 'exp' needs a field to filter"
        }]
      end
      ## subhash.values.first cai dentro da hash do field ('aaa', 'aab', 'aac' etc)
      ## ela deve ter uma subhash com APENAS UMA key que será o operador.
      if !(subhash.values.first.is_a? Hash) or
      subhash.values.first.keys.count !=1 or
      subhash.values.first == {}
        return [false, {
          error: "Wrong operator",
          message: "Each field need a hash with exactly one valid operator"
        }]
      end

      ## field --> campo ternario do banco ('aaa', 'aab', 'aac' etc)
      field = subhash.keys.first
      ## operator --> chave dentro das possibilidades:
      ## include, not_include, exacly, not_exacly, greater_then, less_then
      operator = subhash.values.first.first.first.to_s
      ## value --> valor atribuido ao 'operator'
      value = subhash.values.first.first.second

      ## Retorna erro se 'value' têm 
      #caracteres não permitidos
      if value.class == String and value.match(/[^[:alpha:][0-9]?!@,. \n\t]/)
        return [false, {
          error: "Character not allowed",
          message: "Special characters not allowed in operators"
        }]
      end 

      case operator
      when 'include'
        "(jsonb_path_exists(row, '$ ? ($.#{field} like_regex \"#{value}\" flag \"i\")'))"
      when 'not_include'
        "(not jsonb_path_exists(row, '$ ? ($.#{field} like_regex \"#{value}\" flag \"i\")'))"
      when 'exactly'
        "(row @@ '$.#{field} == #{(value.is_a? Numeric) ? value : "\"#{value}\""}')"
      when 'not_exactly'
        "(not (row @@ '$.#{field} == #{(value.is_a? Numeric) ? value : "\"#{value}\""}'))"
      when 'greater_then'
        "(row @@ '$.#{field} >= #{value}')"
      when 'less_then'
        "(row @@ '$.#{field} <= #{value}')"
      else
        return [false, {
          error: "Wrong operator!",
          message:"Operator '#{operator}' do not exists"
        }]
      end
    end
    return [true, query_array.join(" AND ")]
  end
end
