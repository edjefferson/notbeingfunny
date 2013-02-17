require 'twitter'
require 'mysql'

#heroku config:add DB_HOST= DB_USER= DB_PW= DB_NAME=

con = Mysql.new ENV['DB_HOST'],ENV['DB_USER'],ENV['DB_PW'],ENV['DB_NAME']



#heroku config:add R_CONSUMER_KEY= R_CONSUMER_SECRET= R_OATH_TOKEN= R_OATH_TOKEN_SECRET=


NBFTweets = Twitter.configure do |config|
  config.consumer_key = ENV['R_CONSUMER_KEY']
  config.consumer_secret = ENV['R_CONSUMER_SECRET']
  config.oauth_token = ENV['R_OATH_TOKEN']
  config.oauth_token_secret = ENV['R_OATH_TOKEN_SECRET']
end




result = con.query("select lasttweet from lasttweet where id=1")

readout = result.fetch_row


LatestTweet = NBFTweets.search("\"not being funny but\" -RT", :result_type => "recent", :since_id => readout[0].to_i  ).results.reverse.each do |status|
  
  puts status.text
  finaltweet = "@#{status.user.username} You are definitely not being funny."
  puts finaltweet
  puts status.id
  con.query("update lasttweet set lasttweet=#{status.id} where id=1")
  
  Twitter.update(finaltweet, :in_reply_to_status_id => status.id )
  
end