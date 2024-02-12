class UserController < ApplicationController
  def create
    user = User.new(user_params)
    if user.saves
      render json: user, status: :created 
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
  
  def index
    render json: User.all
  end

  def show
    user = User.find(params[:id])

    if user
      render json: user, status: :ok  
    else
      render json: {message: 'not found'}, status: :not_found
    end
  end

  def update
    user = User.find(params[:id]) 

    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.destroy
      # return a response with only headers and no body
      head :no_content
    else
      render json: user.errors, status: :unprocessable_entity 
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
