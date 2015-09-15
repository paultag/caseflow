Rails.application.routes.draw do
  scope '/caseflow' do
    namespace :files do
      get '/:type/:id', to: :show, as: :show, constraints: {type: /forms/}
    end

    get '/certifications/:id/start', to: 'web#start'
    get '/certifications/:id/questions', to: 'web#questions'
    post '/certifications/:id/questions', to: 'web#questions_submit'
    get '/certifications/:id/generate', to: 'web#generate'
    post '/certifications/:id/certify', to: 'web#certify'
    get '/login', to: 'web#login'
    post '/login', to: 'web#login_submit'
    get '/logout', to: 'web#logout'
  end
end
