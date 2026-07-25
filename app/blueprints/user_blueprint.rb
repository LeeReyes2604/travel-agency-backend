# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :username, :email, :role, :activated_at, :created_at

  field :created_at do |user|
    user.created_at.iso8601
  end
end
