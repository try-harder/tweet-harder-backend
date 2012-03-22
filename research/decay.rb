# encoding: UTF-8

require "sinatra"
require "sinatra/reloader" if development?
require "haml"

require "mongo"

require 'mysql'
require 'sequel'


# Default encoding to utf-8
Encoding.default_external = Encoding::UTF_8 if defined? Encoding

MIN_POINT = 128
MAX_POINT = 1114111 # 1,114,111
MAX_SAFE  = 55295 # 55296..57343 are invalid (2048 invalid points)

configure do
  $mongo = Mongo::Connection.new
  $shunt = MIN_POINT
  $db ||= Sequel.mysql('tweetharder', :user => 'root', :password => 'TUWERGA33FH', :host => '127.0.0.1')
end

before do
  # @versions = $mongo.db('decay').collection('versions')
  @tweets = $mongo.db('decay').collection('tweets')
  @words = $mongo.db('decay').collection('words')

  @terms = $db[:terms]
  @urls = $db[:urls]
  @handles = $db[:handles]
end

get('/') { haml :index }

get('/new') { haml :new }

post '/create' do
  body  = params['body'].to_s
  words = body.split.uniq.sort
  
  old_words = @words.find(word: { '$in'=>words }).to_a.map {|doc| doc['word']}
  new_words = words - old_words
  new_words.each do |word|
    $shunt = $shunt + 1
    char = "" << $shunt
    @words.insert({ val: $shunt, word: word, char: char })
  end

  tweet = { body: body, words: words, created_at: Time.now.utc }
  id = @tweets.insert(tweet)
  redirect '/tweets/' + id.to_s
end

get '/words' do
  haml :words, :locals => { words: @words.find() }
end

get '/tweets' do
  haml :tweets, :locals => { tweets: @tweets.find() }
end

get '/tweets' do
  haml :tweets, :locals => { tweets: @tweets.find() }
end

get '/tweets/:id' do
  tweet = @tweets.find_one("_id"=>BSON::ObjectId.from_string(params['id']))
  words = tweet['words'].uniq
  word_map = Hash.new
  words.each do |word|
    word_map[word] = @words.find_one(word: word)['val']
  end
  output = ""
  words = tweet['body'].split
  words.each do |word|
    output << ("" << word_map[word]) + " "
  end
  haml :tweet, :locals => { tweet: tweet, output: output }
end

get '/decode' do
  tweet = params['tweet']
  words = tweet.split
  output = 
  words.each do |word|
    word_map[word] = @words.find_one(word: word)['word']
  end
end

__END__

@@ layout
%html
  %body
    = yield

@@ index
%div Home
%div
  %a{:href => "new"}
    Create new
%div
  %a{:href => "words"}
    Words
%div
  %a{:href => "tweets"}
    Tweets
%div
  %a{:href => "build"}
    Build


@@ new
%div Create
%div
  %form{ :action => "create", :method => "post"}
    %label{:for => "body"} Message:
    %textarea{:name => "body"}
    %input{:type => "submit", :value => "Add", :class => "button"}
%a{:href => "/"}
  Cancel

@@ words
%div Words
- words.each do |word|
  = word
%a{:href => "/"}
  Back

@@ tweets
%div Tweets
- tweets.each do |tweet|
  %pre
    %code
      = tweet
%a{:href => "/"}
  Back

@@ tweet
%div Tweet
%pre
  %code
    = tweet
%pre
  %code
    = output
%a{:href => "/"}
  Back

@@ new
%div Create
%div
  %form{ :action => "create", :method => "post"}
    %label{:for => "body"} Message:
    %textarea{:name => "body"}
    %input{:type => "submit", :value => "Add", :class => "button"}
%a{:href => "/"}
  Cancel
