# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post "uploadfile", to: "upload#upload"
      resources :user, param: :uid do
        collection do
          post :login
          get :logout
          get :ping_role
          get :profile
          post :change_password
          get :search_email
          get :list_lecturer
        end
      end

      resources :subject, param: :subject_uid do
        collection do
          get :my_subject
          get :search
        end
        member do
          post :create_qr_code
          get :get_qr_today
          get :list_student
          get :attendance_detail
        end
        resources :take_part_in_subject do
          collection do
            post :register
            post :cancel
          end
        end
      end

      get "get_type_event", to: "event#get_type_event"
      resources :event, only: [:index, :show, :update, :destroy], param: :uid do
        collection do
          get :joined_event
          get :list
          get :search_name_basic
          get :search_name
          post :event_comming
          get :quality_event
        end

        resources :token, only: [], module: :event do
          collection do
            get :qr_code
          end
        end

        resources :take_part_in_event, only: [:create], module: :event do
          collection do
            post :cancel
            get :email
          end
        end

        resources :answer, only: [:create], module: :event

        resources :template_feedback, module: :event do
          resources :question, only: [:index]
        end
      end

      resources :tokens, only: [], param: :token_string do
        member do
          get :attendance_by_qr_code
        end
      end

      scope module: :admin do
        get "admin/my_event", to: "event#my_event"
        resources :event, only: [], param: :event_uid do
          member do
            patch :approve_event
            patch :cancel_event
          end
          collection do
            post :event_statistics
            post :event_statistics_by_year
          end
        end
      end

      scope module: :student do
        resources :qr_code, param: :qr_code_string do
          member do
            get :attendance
          end
          collection do
            get :list_attendance
            post :attendance_manual
          end
        end
      end

      namespace :lecturer do
        resources :qr_code, param: :qr_code_string do
          collection do
            post :attendance
          end
        end
      end

      namespace :admin do
        resources :user, only: [:index, :create, :update, :destroy], param: :uid do
          member do
            get :ban
            get :unban
            get :creator
            get :approval
            get :basic
          end
          collection do
            post :count_user
            get :list_lecturer
            get :statistic
          end
        end
        resources :subject, param: :subject_uid do
          member do
            post :open_subject
            post :close_subject
            post :pending_subject
          end
        end
      end

      scope module: :creator do
        resources :user, only: [:index], param: :uid do
          collection do
            post :send_email
          end
        end
        resources :event, only: [:create], param: :uid do
          member do
            get :generate_meeting
          end
          collection do
            get "management/list_event", to: "event#index"
          end
          resources :take_part_in_event, only: [], module: :event do
            collection do
              post "attendance"
              post :export_list_attendance
            end
          end
          resources :token, only: [:create], module: :event
          resources :template_feedback, only: [:create], module: :event do
            resources :question, only: [:create]
          end
          resources :statistical, only: [:index], module: :event
        end
      end

      resources :email, only: [:index, :show], param: :uid

      scope module: :email do
        get :email_by_me
      end

      resources :suggestion, only: [:index] do
        collection do
          get :type_event_statistics
        end
      end
    end
  end
end
