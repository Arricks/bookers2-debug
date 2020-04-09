class BooksController < ApplicationController
  
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :destroy]

  def show
  	@book = Book.find(params[:id])
    @books = Book.all
    @new_book = Book.new
    @user = @book.user
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
    @user = User.find(current_user.id)
  end

  def create
    @book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @books = Book.all
    @book.user_id = current_user.id
    @user = current_user
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@book.id)
      flash[:notice] = "successfully created book!"#保存された場合の移動先を指定。
  	else
      flash[:notice] = "error"
  		render :index
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end

  def new
    @book = Book.find(params[:id])
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to book_path(@book.id), notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
      flash[:notice] = "error"
  		render :edit
  	end
  end

  def delete
  	@book = Book.find(params[:id])
  	@book.destoy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def correct_user
      if current_user != Book.find(params[:id]).user
        redirect_to books_path
      end
  end

  def book_params
  	params.require(:book).permit(:title, :body)
  end

end
