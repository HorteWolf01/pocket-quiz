class User < ApplicationRecord
  has_many :participants
  has_many :quizzes, :through => :participants
  has_many :authored_quizzes, class_name: "Quiz", :foreign_key => :author_id
  has_secure_password
  validates :email, uniqueness: true
  validates :email, :password_digest, :name, presence: true

  private

end

