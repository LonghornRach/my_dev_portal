class User < ApplicationRecord
  store :options, accessors: %i[active_portfolio_id blog_active?]
  has_many :portfolios, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  include Gravtastic
  gravtastic size: 60, filetype: 'gif'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
