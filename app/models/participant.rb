class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  before_save :init

  def init
    self.score ||=0
  end
end
