require 'cinch'

class Karma
  include Cinch::Plugin

  match /((\S+)[\+\?]{2})/

  def initialize(*args)
    super
    @users = Hash.new(0)
  end

  def points_message(nick)
    return "#{ nick } has #{ @users[nick] } awesome points."
  end

  def execute(m)
    cmd = m.params[1]
    tokens = cmd.match(/[!](\S+)([\+\?]{2})/)
    nick = tokens[1]
    action = tokens[2]
    
    if action == '++'
      if nick == @bot.nick
        m.reply "Increasing my karma would result in overflow."
      elsif nick == m.user.nick
        m.reply "Just keep patting yourself on the back there, sport."
      else
        @users[nick] += 1
        m.reply points_message(nick)
      end
    elsif action == '??'
      if nick == 'karma'
        @users.each do |nick, points|
          m.reply points_message(nick)
        end
      else
        m.reply points_message(nick)
      end
    end
  end
end
