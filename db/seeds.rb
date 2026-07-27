
users = [
  {
    username: "admin", first_name: 'tripie_travel', last_name: 'admin', email: "admin@tripietravelandtours.com",
    password: "password", password_confirmation: "password", role: "super_admin", activated_at: Time.current
  }
]

users.each do |user_attrs|
  user = User.find_by(username: user_attrs[:username], email: user_attrs[:email])
  if user.blank?
    User.create!(user_attrs)
    p "User #{user_attrs[:username]} created successfully."
  else
    p "User #{user_attrs[:username]} already exists, skipping..."
  end
end
