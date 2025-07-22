class CategoryPolicy < ApplicationPolicy
  def index?
    user.is_admin? || user.is_writer?
  end

  def show?
    user.is_admin? || user.is_writer?
  end

  def create?
    user.is_admin?
  end

  def new?
    create?
  end

  def update?
    user.is_admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.is_admin?
  end

  class Scope < Scope
    def resolve
      if user.is_admin? || user.is_writer?
        scope.all
      else
        scope.none
      end
    end
  end
end
