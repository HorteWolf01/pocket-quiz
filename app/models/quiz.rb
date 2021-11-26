class Quiz < ApplicationRecord
  has_many :participants
  has_many :users, :through => :participants
  belongs_to :author, class_name: "User", :foreign_key => :author_id
  has_many :questions
  validates :title, presence: true
  before_create :generate_uuid

  private

  def generate_uuid
    begin
    uuid = Faker::Alphanumeric.alphanumeric(number: 7).downcase
    end unless Quiz.find_by(uuid: uuid)
    self.uuid = uuid
  end
end
