Rails.application.routes.draw do
  get '/', to: "quizzes#index"

  #TODO
  resources :quizzes

  namespace :editor do
    ##### quizzes ######
    get 'quizzes', to: 'quizzes#index'
    get 'quizzes/new', to: 'quizzes#new'
    post 'quizzes', to: 'quizzes#create'
    get 'quizzes/:uuid', to: 'quizzes#show'
    get 'quizzes/:uuid/edit', to: 'quizzes#edit'
    put 'quizzes/:uuid', to: 'quizzes#update'
    delete 'quizzes/:uuid', to: 'quizzes#destroy'

    ##### questions #####
    get 'quizzes/:uuid/q/new', to: 'questions#new'
    post 'quizzes/:uuid/q', to: 'questions#create'
    get 'quizzes/:uuid/q/:q', to: 'questions#edit'
    put 'quizzes/:uuid/q/:q', to: 'questions#update'
    delete 'quizzes/:uuid/q/:q', to: 'questions#destroy'

    ##### answers #####
    post 'q/:id/answers', to: 'answers#create'
    put 'answers/:id', to: 'answers#update'
    delete 'answers/:id', to: 'answers#destroy'
  end

  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users, except: [:new]

  get 'email', to: 'sessions#email'

  get ':uuid', to: 'quizzes#connect'
  get ':uuid/results', to: 'quizzes#results'
  get ':uuid/:q', to: 'quizzes#question'
  post ':uuid/:q', to: 'quizzes#send_answer' 
end
