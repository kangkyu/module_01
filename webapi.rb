require 'sinatra'
require 'json'
require 'gyoku'

users = {
  'thibault': { first_name: 'Thibault', last_name: 'Denizet', age: 25 },
  'simon':    { first_name: 'Simon', last_name: 'Random', age: 26 },
  'john':     { first_name: 'John', last_name: 'Smith', age: 28 }
}

post '/users' do
  user = JSON.parse(request.body.read) # {"first_name"=>"Samuel", "last_name"=>"Da Costa", "age"=>19}
  users.merge! user["first_name"].downcase.to_sym => user

  url = "http://localhost:4567/users/#{user["first_name"].downcase.to_sym}"
  response.headers['Location'] = url
  status 201
end

get '/users/:name' do |name|
  send_data json: -> { users.fetch(name.to_sym).merge(id: name) },
             xml: -> { {name => users.fetch(name.to_sym)} }
end

delete '/users/:first_name' do |first_name|
  users.delete(first_name.to_sym)
  status 204
end

get '/users' do
  send_data({
    json: -> { users.map {|name, data| data.merge(id: name)} },
    xml: -> { {users: users} }
  })
end

helpers do

  def send_data(data)
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

    halt 406, "Not Acceptable"
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
