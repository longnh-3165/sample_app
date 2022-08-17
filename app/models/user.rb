class User < ApplicationRecord
  validates :name, presence: true,
            length: {maximum: Settings.digits.length_name_max_50}
  validates :email, presence: true,
            length: {maximum: Settings.digits.length_email_max_255},
            format: {with: Settings.regex.email}
  validates :password, presence: true,
            length: {minimum: Settings.digits.length_password_min_6}

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
