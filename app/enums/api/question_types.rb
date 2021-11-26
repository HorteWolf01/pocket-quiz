module Api::QuestionTypes
  MULTIPLE_CHOICE = 0
  FILL_IN_THE_BLANK = 1
  MULTIPLE_ANSWER = 2
  TRUE_FALSE = 3
  NUMERIC = 4

  TYPE_NAMES = {
    MULTIPLE_CHOICE => 'Multiple choice',
    FILL_IN_THE_BLANK => 'Fill in the blank',
    MULTIPLE_ANSWER => 'Multiple answer',
    TRUE_FALSE => 'True/False',
    NUMERIC = 'Numeric'
  }
end
