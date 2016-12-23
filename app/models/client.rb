class Client < ActiveRecord::Base
  has_many :test_lists
  has_many :histories
  has_many :delayed_runs

  has_secure_password
  validates :password, presence: true,
                       length: { minimum: 3, maximum: 20 },
                       on: :create,
                       confirmation: true

  validates :login, uniqueness: true,
                    presence: true,
                    length: { minimum: 3, maximum: 50 }

  before_save :create_remember_token

  # @return [True, False] is current user is admin
  def admin?
    login == Rails.application.secrets.admin_email
  end

  # @return [True, False] Check if any actions are allowed
  def actions_allowed?
    return true if Rails.env.test?
    return true if admin?
    verified?
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
