class Extension < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates_presence_of :name
  validates_uniqueness_of :name, :allow_nil => true
  validates_presence_of :repository_url, :if => proc {|e| e.download_url.blank? }, :message => "required unless download URL given"
  validates_presence_of :download_url, :if => proc {|e| e.repository_url.blank? }, :message => "required unless repository URL given"
  validates_uniqueness_of :repository_url, :if => :repository_url?
  validates_uniqueness_of :download_url, :if => :download_url?
  validates_presence_of :author_id
  validates_presence_of :repository_type, :if => :repository_url?
  validates_presence_of :download_type, :if => :download_url?
  #validates_presence_of :version
  #validates_presence_of :supports

  after_create  :update_cached_fields
  after_destroy :update_cached_fields

  def self.per_page
    25
  end

  def self.permitted_params
    [
      :name,
      :version,
      :description,
      :homepage_url,
      :documentation_url,
      :supports,
      :repository_url,
      :repository_type,
      :download_url,
      :download_type,
      :installation_instructions,
      :last_pushed_at,
      :watcher_count
    ]
  end

  def install_type
    unless repository_type.blank?
      repository_type
    else
      download_type
    end
  end

  def slug
    name.strip.gsub(/[^a-z0-9]+/i, '-').downcase
  end

  def to_param
    [id, slug].join('-')
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]

    xml.extension do
      xml.tag!("name", name)
      xml.tag!("description", description)
      xml.tag!("homepage-url", homepage_url)
      xml.tag!("documentation-url", documentation_url)
      xml.tag!("supports", supports)
      xml.tag!("repository-url", repository_url)
      xml.tag!("repository-type", repository_type)
      xml.tag!("download-url", download_url)
      xml.tag!("download-type", download_type)
      xml.tag!("last-pushed-at", last_pushed_at)
      xml.tag!("watcher-count", watcher_count)
      xml.tag!("author") do
        xml.tag!("name", author.name)
        xml.tag!("email", author.email)
      end
    end
  end

  protected

    def update_cached_fields
      User.update_all(['extensions_count = ?', Extension.count(:id, :conditions => { :author_id => author_id })], ["id = ?", author_id])
    end

end
