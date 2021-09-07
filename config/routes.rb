Rails.application.routes.draw do
  get '/' => "home#top"
  get 'login' => "user#login_form"
  post "login" => "user#login"
  get 'signup' => "user#signup"
  post 'signup' => "user#new"
  post "logout" => "user#logout"
  resources :words do
    collection do
      get :test
      get :learned_test
      get :favorite_test
      get :wrong_test
      get :result
      get :choice_test
      post :judge
      post :onfavorite
      post :unfavorite
      delete :destroy_all
    end
    member do
      post :learned
      post :forgot
    end
  end
end
