class PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.build({name: params[:player][:name]})

    respond_to do |format|
      if game.save
        format.html  { redirect_to(game) }
        format.js    { render action: :create, locals: {id: player.id} }
      else
        format.html  { render action: :show }
      end
    end
  end

  def update
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:id])
    @player.bowl(params[:score].to_i)

    arrays = @player.frames.sort.map{ |frame| frame.to_a }

    respond_to do |format|
      format.html { redirect_to @game }
      format.js   { render action: :update, locals: {player: @player.to_json, frames: @player.frames.sort.to_json, arrays: arrays.to_json} }
    end
  end
end
