require 'open-uri'
require 'json'

class WordsController < ApplicationController


  def game
    @grid = [].join
    count = 0
    while 15 > count
      count += 1
      @grid << ("a".."z").to_a.sample
    end
  end


  def validate_word_api(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary = open(url).read
    attempt_check = JSON.parse(dictionary)
    if attempt_check["found"] == true
      return true
    else
      return false
    end
  end

  def validate_word_grid(attempt, grid)
    attempt_hash = Hash.new 0
    grid_hash = Hash.new 0
    attempt_array = attempt.gsub(/\W/, "").downcase.split("")
    attempt_array.each { |letter| attempt_hash[letter] += 1 }
    grid.split("").each { |letter| grid_hash[letter.downcase] += 1 }
    answer =  attempt_hash.all? { |key, value| value <= grid_hash[key] }
    return answer
  end


  def score
    @grid = params[:grid]
    @attempt = params[:attempt]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @time = (@end_time - @start_time).round
    @score = 0
    @message = ""


    if validate_word_grid(@attempt, @grid) == false
      @message = "not in the grid!"
      @score = 0
    elsif validate_word_api(@attempt) == false
      @message = "Not an english word"
      @score = 0
    else
      if @time < 5
        @score += 10
      else
        @score -= 10
      end
      @message = "Well done!"
      @score = @attempt.split('').map { |letter| @score += 10 }.inject(:+)
    end
  end
end
