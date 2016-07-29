class GamesController < ApplicationController
  def index
    @games = Game.all
    @game = Game.new
  end

  def create
    game = Game.new(game_params)
    respond_to do |format|
      if game.save
        format.html  { redirect_to(games_path) }
        format.js    { render action: :create, locals: {id: game.id} }
      else
        format.html  { render action: :index }
      end
    end
  end

  def show
    @game = Game.find(params[:id])
    @players = @game.players
  end

  private
    def game_params
      params.require(:game).permit(:name)
    end
end
