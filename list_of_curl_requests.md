Here is a list of curl requests to ensure that everything is still working well. It would be even better had we written some automated tests. . .

```
GET /users
curl -i http://localhost:4567/users

HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 273
X-Content-Type-Options: nosniff
Connection: keep-alive
Server: thin
[
  {"first_name":"Thibault","last_name":"Denizet","age":25,"id":"thibault"},
  {"first_name":"Simon","last_name":"Random","age":26,"id":"simon"},
  {"first_name":"John","last_name":"Smith","age":28,"id":"john"}
]
```

```
POST /users
curl -X POST -i http://localhost:4567/users \
     -H "Content-Type: application/json" \
     -d '{"first_name":"Samuel","last_name":"Da Costa","age":19}'

HTTP/1.1 201 Created
Content-Type: text/html;charset=utf-8
Location: http://localhost:4567/users/Samuel
Content-Length: 0
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Connection: keep-alive
Server: thin
```

```
PUT /users/jane
curl -X PUT -i http://localhost:4567/users/jane \
     -H "Content-Type: application/json" \
     -d '{"first_name":"Jane","last_name":"Smith","age":25}'

HTTP/1.1 201 Created
Content-Type: text/html;charset=utf-8
Content-Length: 0
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Connection: keep-alive
Server: thin


GET /users/jane
curl -i http://localhost:4567/users/jane

HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 62
X-Content-Type-Options: nosniff
Connection: keep-alive
Server: thin
{"first_name":"Jane","last_name":"Smith","age":25,"id":"jane"}
```

```
PATCH /users/thibault
curl -X PATCH -i http://localhost:4567/users/thibault \
     -H "Content-Type: application/json" \
     -d '{"age":26}'

HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 72
X-Content-Type-Options: nosniff
Connection: keep-alive
Server: thin
{"first_name":"Thibault","last_name":"Denizet","age":26,"id":"thibault"}
```

```
DELETE /users/thibault
curl -X DELETE -i http://localhost:4567/users/thibault

HTTP/1.1 204 No Content
X-Content-Type-Options: nosniff
Connection: close
Server: thin

curl -i http://localhost:4567/users

HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 263
X-Content-Type-Options: nosniff
Connection: keep-alive
Server: thin
[
  {"first_name":"Simon","last_name":"Random","age":26,"id":"simon"},
  {"first_name":"John","last_name":"Smith","age":28,"id":"john"},
  {"first_name":"Samuel","last_name":"Da Costa","age":19,"id":"samuel"},
  {"first_name":"Jane","last_name":"Smith","age":25,"id":"jane"}
]
```

```
OPTIONS /users
curl -i -X OPTIONS http://localhost:4567/users

HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8
Allow: HEAD,GET,POST
Content-Length: 0
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Connection: keep-alive
Server: thin
```

Everything looks good. Now our API actually looks like something!
