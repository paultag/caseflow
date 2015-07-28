Caseflow::Application.routes.draw do
  scope '/caseflow' do
    namespace :api, defaults: {format: 'json'} do
      namespace :certifications do
        get '/start/:id', to: :start, as: :start
        post '/generate/:id', to: :generate, as: :generate
        post '/certify/:id', to: :certify, as: :certify
      end
    end
  end
end
