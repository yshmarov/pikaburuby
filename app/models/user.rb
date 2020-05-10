class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first
  
      # Uncomment the section below if you want users to be created if they don't exist
      unless user
         user = User.create(
            email: data['email'],
            name: access_token.info.name,
            image: access_token.info.image,
            provider: access_token.provider,
            uid: access_token.uid,
            token: access_token.credentials.token,
            expires_at: access_token.credentials.expires_at,
            expires: access_token.credentials.expires,
            refresh_token: access_token.credentials.refresh_token,
            password: Devise.friendly_token[0,20],
            confirmed_at: Time.now #autoconfirm user from omniauth
         )
      else #if user account exists - add additional data
        user.name = access_token.info.name
        user.image = access_token.info.image
        user.provider = access_token.provider
        user.uid = access_token.uid
        user.token = access_token.credentials.token
        user.expires_at = access_token.credentials.expires_at
        user.expires = access_token.credentials.expires
        user.refresh_token = access_token.credentials.refresh_token
        user.save!
      end
      user
  end
  has_many :posts
  acts_as_voter

  def username
    self.email.split(/@/).first
  end

end
