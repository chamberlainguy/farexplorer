Rails.application.routes.draw do


  root to: "fares#search"

  get '/searchinit' => 'fares#searchinit', as: :searchinit

  get '/fares' => 'fares#index', as: :fares

  get '/selecto' => 'fares#selecto', as: :selecto
  get '/selectd' => 'fares#selectd', as: :selectd
  get '/selectod' => 'fares#selectod', as: :selecto_done
  get '/selectdd' => 'fares#selectdd', as: :selectd_done

end
