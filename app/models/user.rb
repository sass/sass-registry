require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :extensions, :dependent => :destroy
  
  scope :authors, -> { where("extensions_count > 0") }

  def self.per_page
    25
  end

  def self.extension_authors_count
    count(:conditions => ["extensions_count > 0"])
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
