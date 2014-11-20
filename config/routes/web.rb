Caseflow::Application.routes.draw do
  namespace :web do
    resources :cases
  end
end