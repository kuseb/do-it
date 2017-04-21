class List < ApplicationRecord
  belongs_to :owner, :class_name => 'User', foreign_key: 'user_id'
  has_many :list_subscribers
  has_many :subscribers, through: :list_subscribers, :class_name => 'User'
  has_many :tasks

  def self.is_user_can_modify?(list, current_user)
      list.user_id == current_user.id
  end

  def self.is_user_can_show?(list, current_user, list_subscribers = nil)
    unless list_subscribers
      list_subscribers = list.list_subscribers
    end

    if current_user
      list_subscribers.any? {|ls| ls.user_id == current_user.id} or list.is_public?
    else
      list.is_public?
    end
  end
end
