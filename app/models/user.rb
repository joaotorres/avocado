class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true
  has_many :assignments, foreign_key: :driver_id, dependent: :destroy

  enum :role, { admin: 0, manager: 1, driver: 2 }, default: :driver

  validates :name, presence: true
  validates :company_id, presence: true, unless: :admin?

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def driver?
    role == "driver"
  end
end
