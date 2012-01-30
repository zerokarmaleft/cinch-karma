require 'cinch'

class Karma
  include Cinch::Plugin

  def initialize(*args)
    super
    @scores_file = "karma.json"
    if File.exist? @scores_file
      File.open(@scores_file, "r") do |f|
        @users = JSON.parse(f.read)
        @users.default = 0
      end
    else
      @users = Hash.new(0)
    end
  end

  match /(\S+)[\+]{2}/, method: :increment
  def increment(m, nick)
    if nick == @bot.nick
      m.reply "Increasing my karma would result in overflow."
    elsif nick == m.user.nick
      m.reply "Just keep patting yourself on the back there, sport."
    else
      @users[nick] += 1
      save
      score(m, nick)
    end
  end

  match /(\S+)[\-]{2}/, method: :decrement
  def decrement(m, nick)
    if nick == @bot.nick
      m.reply "I wouldn't do that if I were you..."
    elsif nick == m.user.nick
      m.reply "There are special rooms on this network for self-flagellation."
    else
      @users[nick] -= 1
      save
      score(m, nick)
    end
  end

  match /karma\?(\s+)?(\S+)?/, method: :scores
  def scores(m, cmd, nick)
    if nick
      score(m, nick)
    else
      @users.each { |nick, score| score(m, nick) }
    end
  end
  
  def score(m, nick)
    m.reply "#{ nick } has #{ @users[nick] } awesome points."
  end

  def save
    File.open(@scores_file, "w") do |f|
      f.write(@users.to_json)
    end
  end
end
