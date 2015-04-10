Caseflow::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :certifications do
      get '/start/:id', to: :start, as: :start
    end
  end
end