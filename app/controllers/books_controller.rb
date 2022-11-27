class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def new
    @book = Book.new
  end

  def index
    @books = Book.page(params[:page])
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully create"
     redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
     render action: :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
     flash[:notice] = "Book was successfully update"
     redirect_to book_path(@book.id)
    else
       render action: :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:notice] = "Book was successfully destroy"
    redirect_to '/books'

  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def user_params
      params.require(:user).permit(:name,:profile_image,:introduction)
  end

  def correct_user
    @book = Book.find(params[:id])
    if  current_user != @book.user
      redirect_to '/books'
    end
  end
end