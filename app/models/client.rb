class Client < ActiveRecord::Base
  attr_accessible :login, :password, :password_confirmation, :post, :first_name, :second_name, :project
  has_many :test_lists
  has_many :histories
  has_many :delayed_runs

  has_secure_password
  validates_confirmation_of :password

  validates :password, :presence => true,
            :length => {:minimum => 3, :maximum => 20}

  validates :password_confirmation, :presence => true

  validates :login, :uniqueness => true,
                    :presence => true,
                    :length => {:minimum => 3, :maximum => 20}

  before_save :create_remember_token

  public

  def amazon_client?
    AMAZON_CLIENTS.include?(self.login)
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
  #
  #validates :first_name, :presence => true,
  #                       :length => {:minimum => 3, :maximum => 20}
  #
  #validates :second_name, :presence => true,
  #                        :length => {:minimum => 3, :maximum => 20}
  #
  #validates :post, :presence => true,
  #          :length => {:minimum => 3, :maximum => 20}

end
