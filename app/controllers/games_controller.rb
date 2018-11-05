require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = ('A'..'Z').to_a.sample(10)
    @guess = params[:word]
  end

  def score
    result
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english?(guess)
    response = open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    json['found']
  end

  def result
    grid = params[:grid]
    guess = params[:word]
    if included?(guess.upcase, grid)
      if english?(guess)
      @score = "Congratulations! #{guess.upcase} is valid!"
      else
        @score = "Sorry but #{guess.upcase} is not an english word!"
      end
    else
      @score = "Sorry but #{guess.upcase} can't be built out of #{grid}!"
    end
    @score
  end
end
