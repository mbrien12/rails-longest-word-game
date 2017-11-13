class WordsController < ApplicationController


  def game
    @grid = [].join
    count = 0
    while 10 > count
      count += 1
      @grid << ("a".."z").to_a.sample
    end
  end


  def score
    @answer = params[:answer]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @time = (@end_time - @start_time).round
    @score = "this is your score"
    @message = "yay or nay"
  end
end



