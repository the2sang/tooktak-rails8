Rails.application.routes.draw do
  # 인증
  resource :session
  resources :passwords, param: :token

  # Google OAuth 콜백
  get "/auth/:provider/callback", to: "omniauth_callbacks#google"
  get "/auth/failure", to: "omniauth_callbacks#failure"

  # 대시보드 (루트)
  root "dashboard#show"

  # 조직
  resources :companies

  # 프로젝트
  resources :projects do
    resources :work_orders, shallow: true
    resources :daily_reports, shallow: true
    resources :inspections, shallow: true
    resources :issues, shallow: true
    resources :costs, shallow: true
    resources :billings, shallow: true
    resources :documents, shallow: true
    resources :safety_checks, shallow: true
  end

  # 독립 리소스 (프로젝트 외부에서도 접근)
  resources :work_orders, only: [:index]
  resources :daily_reports, only: [:index]
  resources :inspections, only: [:index]
  resources :issues, only: [:index]
  resources :costs, only: [:index]
  resources :billings, only: [:index]
  resources :documents, only: [:index]
  resources :safety_checks, only: [:index]

  # 자재 (프로젝트와 무관하게 독립 관리)
  resources :materials
  resources :workers

  # 알림
  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
    collection do
      patch :mark_all_as_read
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
