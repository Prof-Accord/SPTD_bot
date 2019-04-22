require 'bundler/setup'
require 'discordrb'
require 'dotenv'
Dotenv.load

class SPTD_Bot
  attr_accessor :bot

  def initialize
    @bot = Discordrb::Commands::CommandBot.new(client_id: ENV["ID"], token: ENV["TOKEN"], prefix: "!")
  end

  def start
    puts "This bot's invite URL is #{@bot.invite_url}"
    puts "Click on it to invite it to your server."
    
    settings

    @bot.run
  end

  def settings
    ### greeting ###
    @bot.message(containing: 'こんにちは') do |event|
      event.respond("<@#{event.user.id}> さん、こんにちは♪")
    end

    ### game ###
    @bot.message(start_with: '!game') do |event|
      event.respond '1から10までの数字を当ててください'
      magic = rand(1..10)
      event.user.await(:guess) do |guess_event|
        guess = guess_event.message.content.to_i
        if guess == magic
          guess_event.respond '正解です！'
        else
          guess_event.respond(guess > magic ? 'ちょっと大きいですよ♪' : 'ちょっと小さいですよ♪')
          false
        end
      end
    end

    ## 新メンバーへの自動挨拶
    @bot.member_join(:username) do |event|
      event.respond "<@#{event.user.name}> さん、はじめまして！
      まずは #はじめにお読みください に目を通してから
      #自己紹介ルーム で自己紹介をお願いします！"
    end
  end
end

sptd_bot = SPTD_Bot.new
sptd_bot.start
