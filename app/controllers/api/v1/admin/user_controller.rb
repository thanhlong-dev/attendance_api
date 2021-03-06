# frozen_string_literal: true

class Api::V1::Admin::UserController < AdminController
  include Util::Generation
  include Statistic
  def index
    users = User.not_admin.order("email ASC")
    render json: users, each_serializer: Api::V1::Admin::UserSerializer
  end

  def ban
    raise Errors::ExceptionHandler::InvalidAction if target_user.inactived?

    target_user.inactived!
    head :accepted
  end

  def unban
    raise Errors::ExceptionHandler::InvalidAction if target_user.actived?

    target_user.actived!
    head :accepted
  end

  def creator
    raise Errors::ExceptionHandler::InvalidAction if target_user.creator?

    target_user.creator!
    head :accepted
  end

  def approval
    raise Errors::ExceptionHandler::InvalidAction if target_user.approval?

    target_user.approval!
    head :accepted
  end

  def basic
    raise Errors::ExceptionHandler::InvalidAction if target_user.basic?

    target_user.basic!
    head :accepted
  end

  def create
    lecture = Lecturer.create!(params_user.merge(status: "actived"))
    password_user = generate_hash_password("password123")
    lecture.hashed_password=password_user
    lecture.role = 1
    lecture.save!

    head :created
  end

  def count_user
    users = User.not_admin.count
    render json: { count_user: users }, status: :ok
  end

  def list_lecturer
    users = Lecturer.all

    render json: users, each_serializer: Api::V1::Admin::UserSerializer
  end

  def statistic
    render json: statistic_detail
  end

  private
    def target_user
      @user ||= User.find(params[:uid])
    end

    def params_user
      params.permit(
        :email,
        :name,
        :phone,
        :avatar,
        :gender,
      )
    end
end
