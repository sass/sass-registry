require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:github]

  has_many :extensions, foreign_key: 'author_id', dependent: :destroy
  
  scope :authors, -> { where("extensions_count > 0") }

  def self.per_page
    25
  end

  def self.extension_authors_count
    count(:conditions => ["extensions_count > 0"])
  end

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create(
        name:     auth.extra.raw_info.name,
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email,
        password: Devise.friendly_token[0,20],
        bio:      auth.extra.raw_info.bio,
        website:  auth.extra.raw_info.blog,
        company:  auth.extra.raw_info.company,
        location: auth.extra.raw_info.location,
        available_for_hire: auth.extra.raw_info.hireable
      )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.bio = data["bio"] if user.bio.blank?
        user.website = data["blog"] if user.website.blank?
        user.company = data["company"] if user.company.blank?
        user.location = data["location"] if user.location.blank?
        user.available_for_hire = data["hireable"] if user.available_for_hire.blank?
      end
    end
  end
  
  def to_param
    [id, name].join('-').strip.gsub(/[^a-z0-9]+/i, '-').downcase
  end
  
  # TODO: what here?
  def to_xml(options={}, &block)
    super(options.reverse_merge(:except => [:encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip]), &block)
  end

  def display_name
    unless name.blank?
      name
    else
      email
    end
  end
  
  alias to_s display_name
  alias to_str to_s

end
