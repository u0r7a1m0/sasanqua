Rails.application.routes.draw do
  namespace :admin do
    get 'homes/top'
  end
    # 顧客用
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    omniauth_callbacks: "omniauth_callbacks"
  }
  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  root to: 'public/homes#top'
  scope module: :public do
    get '/about' => 'homes#about'
    get '/privacy_policy' => 'homes#privacy'

    # 「customers」
    get '/customers/my_page' => 'customers#show', as: 'my_page'
    get '/customers/information/edit' => 'customers#edit', as: 'customers_edit'
    patch '/customers/information' => 'customers#update', as: 'information'
    get '/customers/unsubscribe' => 'customers#unsubscribe', as: 'unsubscribe'
    patch '/customers/withdraw' => 'customers#withdraw', as: 'withdraw'
    get '/routines/bookmark' => 'routines#like', as: 'bookmark'

    resources :routines do
      resources :sub_task_commits
      resources :task_commits
    end
    resources :bookmarks, only: [:create, :destroy, :index]

    resources :routines, except: [:index] do
      resource :bookmarks, only: [:create, :destroy, :index, :like]
    end


  end
  #####################
  # 管理者側のルーティング設定
  ## URLの頭に「admin」入れる設定
  namespace :admin do
    root to: 'homes#top'
    resources :routines, :customers

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
