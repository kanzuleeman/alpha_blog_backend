class ArticlePolicy < ApplicationPolicy
  def index?
    user.is_admin? || user.is_editor? || user.is_writer?
  end

  def create?
    user.is_writer?
  end

  def update?
    return true if user.is_writer? && record.user_id == user.id
    return true if user.is_editor? && record.pending_review?
    return true if user.is_admin? && record.approved?
    
    false
  end

  def destroy?
    user.role == 'writer' && record.user_id == user.id
  end

  def submit?
    user.is_writer?
  end

  def approve?
    user.is_editor?
  end

  def reject?
    user.is_editor?
  end

  def publish?
    user.is_admin?
  end

  def pending_review?
    user.is_editor?
  end

  def approved?
    user.is_admin?
  end

  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      elsif user.is_editor?
        scope.where(status: [:pending_review, :approved])
      elsif user.is_writer?
        scope.where(user: user)
      else
        scope.where(status: :published)
      end
    end
  end
end
