Rails.application.routes.draw do
  scope '/caseflow' do
    get '/certifications/:id/start', to: 'web#start'
    get '/certifications/:id/questions', to: 'web#questions'
    post '/certifications/:id/questions', to: 'web#questions_submit'
    get '/certifications/:id/generate', to: 'web#generate'
    post '/certifications/:id/certify', to: 'web#certify'
    post '/certifications/:id/error', to: 'web#error'

    get '/files/forms/:id', to: 'web#show_form'

    get '/login', to: 'web#login'
    post '/login', to: 'web#login_ro_submit'
    get '/logout', to: 'web#logout'

    post '/users/auth/saml/callback', to: 'web#ssoi_saml_callback'
  end
end
