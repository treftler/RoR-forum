class ArticlesController < ApplicationController
  
  $posts_per_page = 10     #１ページあたりの件数

  #管理者ページのID、パスワードを設定
  http_basic_authenticate_with name: "admin", password: "admin", only: :admin

  #トップページの情報を取得、表示
  def index
    total_posts = Article.count                       #コメントの総数
    @total_pages = total_posts / $posts_per_page + 1  #ページの総数
    @are_more_pages = @total_pages > 1                #ページ総数が２ページ以上ならtrue
    page_min_id = total_posts - $posts_per_page + 1   #現ページの投稿の最小id
    
    #　もし２ページ以上あるなら、最新の$posts_per_page件の投稿のみ取得、
    #　１ページのみ場合は投稿を全て取得
    if @are_more_pages
      @articles = Article.where("id >= ?",  page_min_id).limit($posts_per_page)
    else
      @articles = Article.all
    end
  end
  
  #投稿後の内容表示
  def show
    @article = Article.find(params[:id])
  end
  
  #新しいコメントの作成画面
  def new
    @article = Article.new
  end
  
  #投稿を編集（今回のアプリケーションでは未使用）
  def edit
  end
  
  #newにて新しいコメント作り、submitボタン押した後、データベースに内容を保存
  def create
    @article = Article.new(article_params)
    
    #　エラーがなければデータベースに保存し、
    #　エラーがあった場合は作成画面に戻る
    if @article.save
      redirect_to @article
      else
      render 'new'
    end
  end
  
  #編集後の内容をデータベースに保存（今回のアプリケーションでは未使用）
  def update
  end
  
  #投稿をデータベースから消去（今回のアプリケーションでは未使用）
  def destroy
  end
  
  #投稿を削除、掲示板には削除済みと表示
  def delete
    @article = Article.find(params[:id])
    @article.name = "--"
    @article.email = "--"
    @article.text = "--deleted--"
    @article.save
    
    redirect_to article_admin_path
  end
  
  #２ページ目以降の表示
  def page
    total_posts = Article.count                       #コメントの総数
    @total_pages = total_posts / $posts_per_page + 1  #ページの総数
    @current_page = params[:number].to_i              #現在のページ（トップページ＝１、次のページ＝２、・・・）
    @are_more_pages = @total_pages > @current_page    #次ページが存在するならtrue
    page_min_id = total_posts - $posts_per_page * @current_page + 1  #現ページの投稿の最小id
    
    # urlを http://~~~/articles/page/-1 などとした場合にはトップページに飛ばす
    if @current_page <= 1
      redirect_to articles_path
    end
    
    #　次のページが存在する場合、現ページの$posts_per_page件の投稿を取得し、
    #　現ページが最後のページならば、残った端数の投稿を抽出して取得
    if @are_more_pages
      @articles = Article.where("id >= ?", page_min_id).limit($posts_per_page)
    else
      @articles = Article.limit(total_posts % $posts_per_page)
    end
  end
  
  #全ての投稿を取得、表示
  def all
    @articles = Article.all
  end
  
  #管理者用画面を表示
  def admin
    @articles = Article.all
  end
  
  private
  #テキストボックスにて送信可能なパラメータを設定
  def article_params
      params.require(:article).permit(:name, :email, :text)
  end
  
end
