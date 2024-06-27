class PagesPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def assistant?
    user && user.manager?
  end
end