class ExtensionsController < ApplicationController
  before_filter :assign_extension, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :only => [:new, :edit, :update, :destroy]
  before_filter :require_correct_permissions, :only => [:edit, :update, :destroy]

  ORDER_BY = {
    'name' => 'name',
    'updated' => 'updated_at DESC'
  }
  
  # GET /extensions
  # GET /extensions.atom
  def index
    @order = params[:order]
    @order ||= 'name'
    
    respond_to do |format|
      format.html { @extensions = Extension.paginate :page => params[:page], :order => ORDER_BY[@order], :include => :author }
      format.xml  { @extensions = Extension.find(:all, :order=>"updated_at DESC", :include => :author); render :xml => @extensions }
      format.atom { @extensions = Extension.find(:all, :order=>"updated_at DESC", :include => :author) }
    end
  end
  
  def all
    @extensions = Extension.paginate :page => params[:page], :order => 'name', :per_page => Extension.count, :include => :author
    render :action => :index
  end
  
  # GET /extensions/1
  # GET /extensions/1.xml
  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @extension }
    end
  end
  
  # GET /extensions/new
  def new
    @extension = Extension.new
  end

  # GET /extensions/import
  def import
    @extension = Extension.new
  end
  
  # GET /extensions/1/edit
  def edit
  end

  # POST /extensions
  # POST /extensions.xml
  def create
    if params[:project_url]
      @extension = extension_from_project_url(params[:project_url])
      @from_url = import_extension_url
    else
      @extension = Extension.new(extension_params)
      @from_url = new_extension_url
    end
    @extension.author = current_user
    respond_to do |format|
      if @extension.save
        format.html { redirect_to extension_url(@extension), notice: 'Created successfully!' }
        format.js
        format.xml  { head :created, :location => extension_url(@extension) }
      else
        logger.info "Errors: " + @extension.errors.inspect
        format.html { redirect_to @from_url, flash: { error: @extension.errors.to_a.first } }
        format.js
        format.xml  { render xml: @extension.errors.to_xml, status: :unprocessible_entity }
      end
    end
  end
  
  # PUT /extensions/1
  # PUT /extensions/1.xml
  def update
    respond_to do |format|
      if @extension.update_attributes(extension_params)
        format.html { flash[:notice] = 'Updated successfully!'; redirect_to extension_url(@extension) }
        format.js
        format.xml  { head :ok }
      else
        format.html { flash[:error] = 'There was a problem saving!'; render :action => "edit", :status => 422 }
        format.js
        format.xml  { render :xml => @extension.errors.to_xml, :status => :unprocessible_entity }
      end
    end
  end

  # DELETE /extensions/1
  # DELETE /extensions/1.xml
  def destroy
    if @extension.destroy
      respond_to do |format|
        format.html { flash[:notice] = "Record deleted!"; redirect_to extensions_url }
        format.js
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { flash[:error] = "There was a problem deleting!"; redirect_to :back, :status => :failure }
        format.js
        format.xml  { head :failure }
      end
    end
  end
  
  protected
    
    def assign_extension
      @extension = Extension.find(params[:id])
    end

    def extension_params
      params.require(:extension).permit(*Extension.permitted_params)
    end

    def extension_from_project_url(project_url)
      project = GitHubProject.new(project_url)

      # Some of these things we can populate from the repo info if not provided by the manifest
      defaults = {
        name: project.reponame,
        description: project.description,
        homepage_url: project.homepage
      }

      # Overrides will be ignored if specified in the manifest
      overrides = {
        repository_url: project.repository_url,
        repository_type: 'Git',
        last_pushed_at: project.updated_at,
        watcher_count: project.watchers
      }

      # Fetch and merge the manifest
      data = project.file('sassmanifest.json')
      manifest = JSON.parse(data)
      manifest.reverse_merge!(defaults).merge!(overrides)

      # Use ActionController::Parameters to make sure nothing malicious is being passed
      safe_params = ActionController::Parameters.new(manifest).permit(*Extension.permitted_params)

      Extension.new(safe_params)
    end
    
    def require_correct_permissions
      unless can_edit?(@extension)
        respond_to do |format|
          format.html do
            redirect_to extensions_url, flash: { error: "You can only edit your own extensions." }
          end
          format.xml { head :forbidden }
        end
        return false
      end
    end
  
end
