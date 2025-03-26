# ElixirJwtAuthServer

This is a **JWT-based authentication API** built in **Elixir** using *Joken, Plug, MongoDB, and Argon2*. It enables **user session validation** by issuing and verifying JWTs, ensuring secure authentication.

## Environment Dependencies

Ensure you have the following environment dependencies installed:

- [Elixir](https://elixir-lang.org/) (1.18+)
- [MongoDB](https://www.mongodb.com/) (running preferably as a docker container)
- Required Elixir libraries (handled via `mix`):
  - `bandit`
  - `joken`
  - `argon2_elixir`
  - `mongodb_driver`
  - `jason`

## Setup Instructions

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/v01dw4lk3r-1337/elixir_jwt_auth_server.git
   cd elixir_jwt_auth_server
   ```
2. **Install Dependencies:**
   ```sh
   mix deps.get
   ```
3. **Configure MongoDB Connection:**
   Update `config/config.exs` with your MongoDB connection details:
   ```elixir
   config :elixir_jwt_auth_server, :mongo,
     url: "mongodb://localhost:27017/auth_db"
   ```
4. **Set Environment Variables (for JWT Secret):**
   ```sh
   export JWT_SECRET="your_super_secret_key"
   ```
5. **Start the Application:**

    Execute the following in the project root dir.
   ```sh
   mix run --no-halt
   ```
   or if you'd like to test out some functions with iex
   ```sh
   iex -S mix
   ```

## API Endpoints

### 1. User Sign-in
   **Endpoint:** `POST /api/v1/auth/signin`
   
   **Request Body:**
   ```json
   {
       "username": "spongebob",
       "password": "secret_formula"
   }
   ```
   **Response:**
   ```json
   {
       "success": "User authenticated successfully!",
       "token": "your_jwt_token_here"
   }
   ```

### 2. Token Validation (Check Status)
   **Endpoint:** `POST /api/v1/auth/check_status`
   
   **Headers:**
   ```
   Authorization: Bearer your_jwt_token_here
   ```
   **Response (Valid Token):**
   ```json
   {
    "success": "Token is valid",
    "claims": {
        "aud": "Joken",
        "exp": 1742961442,
        "iat": 1742961382,
        "iss": "Joken",
        "jti": "30o3s95aneeusn6ttc000264",
        "nbf": 1742961382,
        "sub": "spongebob"
    }
  }
  ```
  
  **Response (Invalid Token):**
  ```json
  {
    "error": "Invalid or expired token",
    "error_code": "INVALID_TOKEN"
  }
  ```

## Notes
- Ensure MongoDB is running before starting the app.
- Tokens expire based on the `exp` claim (default: 60 seconds). Adjust in `JwtConfig.ex` if needed.
- This is a minimal example. In production, consider using HTTPS and stronger security practices.


## Installation (TODO)

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_jwt_auth_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_jwt_auth_server, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/elixir_jwt_auth_server>.

---
Made with ❤️ in Elixir!
