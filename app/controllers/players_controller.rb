class PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    game.players.build({name: params[:player][:name]})

    respond_to do |format|
      if game.save
        format.html  { redirect_to(game) }
      else
        format.html  { render :action => "show" }
      end
    end
  end

  def update
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:id])
    @player.bowl(params[:score].to_i)
    redirect_to @game
  end
end
