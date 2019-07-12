module NestedLoginRender
  extend ActiveSupport::Concern
  private
    def respond_with(resource, _opts = {})
      result = resource.as_json
      result["user_attributes:"] = resource.user.as_json.except("id")
      if result["user_attributes:"].has_key? "company_id"
        result["user_attributes:"]["company__attributes"] = resource.user.company
      end
      render json: result
    end
end
