require 'sinatra'
require 'json'
require 'gyoku'

users = {
  'thibault': { first_name: 'Thibault', last_name: 'Denizet', age: 25 },
  'simon':    { first_name: 'Simon', last_name: 'Random', age: 26 },
  'john':     { first_name: 'John', last_name: 'Smith', age: 28 }
}

deleted_users = {}

# Routes
patch '/users/:name' do |name|
  halt 415 unless request.env["CONTENT_TYPE"] == 'application/json'

  begin
    user = JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    message = {message: e.to_s}
    halt 400, send_data(json: ->{ message }, xml: ->{ message })
  end

  halt 410 if deleted_users[name.to_sym]
  halt 404 unless users[name.to_sym]
  existing = users[name.to_sym]
  user.each do |key, value|
    existing[key.to_sym] = value
  end
  send_data \
    json: -> { existing.merge(id: name) },
    xml:  -> { {name => existing} }
end

put '/users/:name' do |name|
  halt 415 unless request.env["CONTENT_TYPE"] == 'application/json'

  begin
    user = JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    message = {message: e.to_s}
    halt 400, send_data(json: ->{ message }, xml: ->{ message })
  end

  existing = users[name.to_sym]
  users[name.to_sym] = user
  status (existing ? 204 : 201)
end

post '/users' do
  halt 415 unless request.env["CONTENT_TYPE"] == 'application/json'

  begin
    user = JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    message = { message: e.to_s }
    halt 400,
      send_data( json: -> { message },
                  xml: -> { message } )
  end

  id = user["first_name"].downcase.to_sym
  if users[id]
    message = { message: "User #{id} already in DB." }
    halt 409,
      send_data( json: -> { message },
                  xml: -> { message } )
  end

  users.merge! id => user
  url = "http://localhost:4567/users/#{id}"
  response.headers['Location'] = url
  status 201
end

get '/users/:name' do |name|
  halt 410 if deleted_users[name.to_sym]
  halt 404 unless users[name.to_sym]

  send_data \
    json: -> { users[name.to_sym]&.merge(id: name) },
    xml:  -> { {name => users[name.to_sym]} }
end

delete '/users/:first_name' do |first_name|
  id = first_name.to_sym
  deleted_users[id] = users[id] if users[id]
  users.delete(id)
  status 204
end

options '/users/:name' do |name|
  response.headers['Allow'] = "GET,DELETE,PUT,PATCH"
end

put '/users' do
  halt 405
end

patch '/users' do
  halt 405
end

delete '/users' do
  halt 405
end

options '/users' do
  response.headers['Allow'] = 'HEAD,GET,POST'
  status 200
end

head '/users' do
  send_data {}
end

get '/users' do
  send_data \
    json: -> { users.map {|name, data| data.merge(id: name)} },
    xml:  -> { {users: users} }
end

# Helpers
helpers do

  def send_data(data = {})
    case media_type
    when 'json'
      content_type 'application/json'
      data[:json].call.to_json if data[:json]
    when 'xml'
      content_type 'application/xml'
      Gyoku.xml(data[:xml].call) if data[:xml]
    end
  end

  def media_type
    @media_type ||= accepted_media_type
  end

  def accepted_media_type
    return 'json' unless request.accept.any? # request.accept is an array of Sinatra::Request::AcceptEntry

    request.accept.each do |type|
      return 'json' if json_or_default?(type)
      return 'xml' if xml?(type)
    end

    content_type 'text/plain'
    halt 406, 'application/json, application/xml'
  end

  def json_or_default?(type)
    %(application/json application/* */*).include?(type.to_s)
  end

  def xml?(type)
    type.to_s == 'application/xml'
  end
end

get '/' do
  'Master Ruby Web APIs - Chapter 2'
end

get '/debug' do
  content_type 'application/json'
  request.accept.to_json
end
