alias SnowPortal.Accounts

Accounts.register_user(%{
  email: "user@mobilixir.com",
  password: "User@Mobilixir11",
  first_name: "User",
  last_name: "Mobilixir",
  user_name: "user",
  role: "USER"
})

Accounts.register_user(%{
  email: "admin@mobilixir.com",
  password: "Admin@Mobilixir11",
  first_name: "Admin",
  last_name: "Mobilixir",
  user_name: "admin",
  role: "ADMIN"
})

Accounts.register_user(%{
  email: "executive@mobilixir.com",
  password: "Executive@Mobilixir11",
  first_name: "Executive",
  last_name: "Mobilixir",
  user_name: "executive",
  role: "EXECUTIVE"
})
