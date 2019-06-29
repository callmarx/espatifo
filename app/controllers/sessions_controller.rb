class SessionsController < Devise::SessionsController
  respond_to :json

  private
    def respond_with(resource, _opts = {})
      # Como perk é um metodo de user sem registro em sua tabela temos que inclui-lo na exibição do usuário
      result = resource.as_json
      result["perk_type"] = resource.perk.class.to_s
      render json: result
    end
    def respond_to_on_destroy
      head :ok
    end

end
