# Bookstore

To start your Phoenix server:
  * Run `docker-compose up`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To interact through the graphql api
  * You'll need a user token, register or log in and go to settings to get your token
  * You can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) and point to the graphql entry point: `localhost:4000/graphiql`
  * Make sure you send the `Authorization` header with the value `Bearer {token}`
Now you can query authors, categories and books and also mutate authors and categories

To make your server api publicly visible through an url you can use ngrok
  * Configure ngrok following it's installation guide
  * Run `ngrok http --domain=forcibly-ethical-kiwi.ngrok-free.app 4000`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
