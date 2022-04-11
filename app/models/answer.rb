class Answer < ApplicationRecord
  belongs_to :question
  validates :text, presence: true
  validates :right, inclusion: {in: [true, false]}
end
