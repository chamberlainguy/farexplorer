Rails.application.routes.draw do


   # Temp root

  # root to: 'fares2#index'

  root to: 'fares2#search'

  get '/searchinit' => 'fares2#searchinit', as: :searchinit

  get '/fares' => 'fares2#index', as: :fares

  get '/selecto' => 'fares2#selecto', as: :selecto
  get '/selectd' => 'fares2#selectd', as: :selectd
  get '/selectod' => 'fares2#selectod', as: :selecto_done
  get '/selectdd' => 'fares2#selectdd', as: :selectd_done

end
