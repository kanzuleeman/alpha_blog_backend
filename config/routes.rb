Rails.application.routes.draw do
  # config/routes.rb


  namespace :api do
    namespace :auth do
      get 'session', to: 'sessions#show'
      post 'session', to: 'sessions#create'
      delete 'session', to: 'sessions#destroy'
      post 'login', to: 'sessions#create'
    end

    namespace :v1 do
      resources :categories
      resources :users, only: [:create, :index]

      resources :articles do
        member do
          patch :submit        # Writer submits for review (draft → pending_review)
          patch :approve       # Editor approves (pending_review → approved)
          patch :reject        # Editor rejects (pending_review → rejected)
          patch :publish       # Admin publishes (approved → published)
        end

        collection do
          get :published       # Public view
          get :pending_review  # Editor's view
          get :approved        # Admin's view
        end
      end
    end
  end
end
