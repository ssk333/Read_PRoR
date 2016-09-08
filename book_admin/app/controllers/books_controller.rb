class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  def require_login
    #ログインを確認し，非ログイン時にリダイレクトする処理
  end

  def show
    @book = Book.find(params[:id])
    respond_to do |format|
      format.html
      format.csv
      format.json
    end
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end
end

class LoginController < ApplicationController
  # 「ログインをするための画面」にログインが必要では
  # いつまでもログインが出来ないので，require_loginをスキップする．
  skip_before_action :require_login, only:[:new,:create]
end
