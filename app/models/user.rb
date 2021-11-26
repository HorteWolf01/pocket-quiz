class User < ApplicationRecord
  has_many :participants
  has_many :quizzes, :through => :participants
  has_many :authored_quizzes, class_name: "Quiz", :foreign_key => :author_id
  has_secure_password
  before_create :generate_apitoken
  validates :login, :apitoken, uniqueness: true
  validates :login, :password_digest, :name, presence: true

  private

  def generate_apitoken
    apitoken = SecureRandom.urlsafe_base64.to_s
    apitoken = Digest::SHA1.hexdigest apitoken
    self.apitoken = apitoken
  end
end
