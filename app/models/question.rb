class Question < ApplicationRecord
  has_many :answers
  belongs_to :quiz
  validates :text, presence: true
  before_create :init

  enum question_type: {
    'Multiple choice': 0,
    'Fill in the blank': 2,
    'Multiple answer': 5,
    'True': 4,
    'False': 3,
    'Numeric': 1
  }

  private
  
  def init
    self.points ||=1
  end

end
