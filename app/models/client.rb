class Client < ActiveRecord::Base
  has_many :test_lists
  has_many :histories
  has_many :delayed_runs

  has_secure_password
  validates_confirmation_of :password

  validates :password, presence: true,
                       length: { minimum: 3, maximum: 20 }

  validates :password_confirmation, presence: true

  validates :login, uniqueness: true,
                    presence: true,
                    length: { minimum: 3, maximum: 20 }

  before_save :create_remember_token

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
