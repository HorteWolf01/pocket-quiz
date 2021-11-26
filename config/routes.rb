Rails.application.routes.draw do
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do

    #users
    get 'user/auth', to: 'users#auth'

    get 'users', to: 'users#index'
    get 'user/:id', to: 'users#show'
    put 'user', to: 'users#add'
    put 'user/:id', to: 'users#update'
    delete 'user/:id', to: 'users#destroy'
    get 'user/:id/quizzes', to: 'users#authored_quizzes'
    
    #participants
    get 'user/:id/scores', to: 'participants#user'
    get 'quiz/:uuid/participants', to: 'participants#quiz'

    #quizzes
    get 'quiz/:uuid/author', to: 'quizzes#author'

    get 'quizzes', to: 'quizzes#index'
    post 'user/:id/quiz', to: 'quizzes#new'
    get 'quiz/:uuid', to: 'quizzes#show'
    post 'quiz/:uuid', to: 'quizzes#update'
    delete 'quiz/:uuid', to: 'quizzes#destroy'

    #questions
    get 'quiz/:uuid/questions', to: 'questions#index'
    get 'quiz/:uuid/:q', to: 'questions#show'
    delete 'quiz/:uuid/:q', to: 'questions#destroy'
    post 'quiz/:uuid/add', to: 'questions#add'
    post 'quiz/:uuid/:q', to: 'questions#add_answer'
    post 'quiz/:uuid/:q/:a', to: 'questions#update_answer'
    delete 'quiz/:uuid/:q/:a', to: 'questions#destroy_answer'
    get 'quiz/:uuid/:q/:a', to: 'questions#show_answer'
 
  end
  
  get ':uuid', to: 'quizzes#connect'
  get ':uuid/results', to: 'quizzes#results'
  get ':uuid/:q', to: 'quizzes#question'
  post ':uuid/:q', to: 'quizzes#send_answer'

end
