Rails.application.routes.draw do
  namespace :api do
    post "robot/0/orders" => 'robot#orders'
  end
end