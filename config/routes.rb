Rails.application.routes.draw do
  scope '/caseflow' do
    root to: 'web#index'

    namespace :files do
      get '/:type/:id', to: :show, as: :show, constraints: {type: /forms/}
    end

    get '/certifications/:id/start', to: 'web#redirect'
  end
end
