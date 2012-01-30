require 'cinch'

class Karma
  include Cinch::Plugin

  def initialize(*args)
    super
    @users = Hash.new(0)
  end

  match /(\S+)[\+]{2}/, method: :increment
  def increment(m, nick)
    if nick == @bot.nick
      m.reply "Increasing my karma would result in overflow."
    elsif nick == m.user.nick
      m.reply "Just keep patting yourself on the back there, sport."
    else
      @users[nick] += 1
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
end
