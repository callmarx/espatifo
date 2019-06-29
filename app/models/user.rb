class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  # define o privilegio/perfil do usuário
  @perk = nil
  # Se for Employee esta vinculado à um conjunto especifico de projetos
  @projects = nil

  def perk
    @perk
  end

  def projects
    @projects
  end

  # Garatem um único acesso ao banco para definir @perk e @projects
  after_find do
    if @perk = Employee.find_by_user_id(self.id)
      @projects = @perk.projects
    else @perk = Operational.find_by_user_id(self.id)
    end
  end
  ## Novas entidades de privilégio devem serem incluidas neste case/when
  def register(perk:, company_id: nil, first_name:, second_name:, birthdate: nil)
    if !@perk
      case perk
      when "Employee"
        if company = Company.find_by_id(company_id)
          @perk = Employee.create(user: self, company: company, first_name: first_name, second_name: second_name, birthdate: birthdate)
          @projects = @perk.projects
          @perk
        end
      when "Operational"
        @perk = Operational.create(user: self, first_name: first_name, second_name: second_name, birthdate: birthdate)
        @perk
      end
      nil
    end
  end

end
