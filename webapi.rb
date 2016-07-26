require 'sinatra'
require 'json'

require 'gyoku'

users = {
  'thibault': { first_name: 'Thibault', last_name: 'Denizet', age: 25 },
  'simon':    { first_name: 'Simon', last_name: 'Random', age: 26 },
  'john':     { first_name: 'John', last_name: 'Smith', age: 28 }
}

get '/users' do
  case accepted_media_type
  when 'json'
    content_type 'application/json'
    users.map {|name, data| data.merge(id: name)}.to_json
  when 'xml'
    content_type 'application/xml'
    Gyoku.xml(users: users)
  end
end

get '/' do
  'Master Ruby Web APIs - Chapter 2'
end

get '/debug' do
  content_type 'application/json'
  request.accept.to_json
end

def accepted_media_type
  return 'json' unless request.accept.any? # request.accept is an array of Sinatra::Request::AcceptEntry

  request.accept.each do |mt|
    return 'json' if %(application/json application/* */*).include?(mt.to_s)
    return 'xml' if mt.to_s == 'application/xml'
  end

  halt 406, "Not Acceptable"
end
