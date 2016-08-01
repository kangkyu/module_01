6.2 Global

We will add error handling for each route, but let's first see the errors we need to handle for every request.

6.2.1 405

curl -i -X PUT http://localhost:4567/users

"Method Not Allowed" when the client tries to access a resource using an unsupported HTTP method. what would happen if a client tried to use the PUT method with the /users URI?

6.2.2 406

curl -i http://localhost:4567/users -H "Accept: moar/curl"

6.3 POST

6.3.1 415

curl -X POST -i http://localhost:4567/users \
     -H "Content-Type: application/fake" \
     -d 'Weirdly Formatted Data'

6.3.2 400

curl -X POST -i http://localhost:4567/users \
     -H "Content-Type: application/json" \
     -d '{"first_name":"Mark"'

6.3.3 409

curl -X POST -i http://localhost:4567/users \
     -H "Content-Type: application/json" \
     -d '{"first_name":"Thibault","last_name":"Denizet","age":25}'

curl -X POST -i http://localhost:4567/users \
     -H "Content-Type: application/json" \
     -d '{"first_name":"Mark","last_name":"Twain","age":25}'

6.4 GET /users/mark

6.4.1 404
6.4.2 410

6.5 PUT

6.5.1 415
6.5.2 400

6.6 PATCH /users/mark

415 Unsupported Media Type
404 Not Found
410 Gone
400 Bad Request
