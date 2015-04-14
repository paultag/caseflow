Rails.application.routes.draw do
  root to: 'web#index'

  namespace :files do
    get '/:type/:id', to: :show, as: :show, constraints: {type: /forms/}
  end
end
