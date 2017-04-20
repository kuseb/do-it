class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
<<<<<<< Updated upstream
=======

  has_many :lists
  has_many :lists, through: :list_subscribers
>>>>>>> Stashed changes
end
