class Spree::LabelTemplatesController < Spree::ResourceController
  include Spree::Core::ControllerHelpers::Order
  before_filter :load_data
  
  # GET /label_templates
  # GET /label_templates.json
  def index
    @label_templates = Spree::LabelTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @label_templates }
    end
  end

  # GET /label_templates/1
  # GET /label_templates/1.json
  def show
    @label_template = Spree::LabelTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @label_template }
    end
  end

  # GET /label_templates/new
  # GET /label_templates/new.json
  def new
    @label_template = Spree::LabelTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @label_template }
    end
  end

  # GET /label_templates/1/edit
  def edit
    @label_template = Spree::LabelTemplate.find(params[:id])
  end

  # POST /label_templates
  # POST /label_templates.json
  def create
    @label_template = Spree::LabelTemplate.new(params[:label_template])

    respond_to do |format|
      if @label_template.save
        format.html { redirect_to @label_template, notice: 'Label template was successfully created.' }
        format.json { render json: @label_template, status: :created, location: @label_template }
      else
        format.html { render action: "new" }
        format.json { render json: @label_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /label_templates/1
  # PUT /label_templates/1.json
  def update
    @label_template = Spree::LabelTemplate.find(params[:id])

    respond_to do |format|
      if @label_template.update_attributes(params[:label_template])
        format.html { redirect_to @label_template, notice: 'Label template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @label_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /label_templates/1
  # DELETE /label_templates/1.json
  def destroy
    @label_template = Spree::LabelTemplate.find(params[:id])
    @label_template.destroy

    respond_to do |format|
      format.html { redirect_to label_templates_url }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def load_data
    @current_category = params[:c]
    @product = Spree::Product.find_by_permalink(params[:product_id])
    @label_templates = Spree::LabelTemplate.all
    @label_groups = Hash.new
    @label_templates.each do |template|
      group = @label_groups[template.group]
      group = group == nil ? [] : group
      group << template
      @label_groups[template.group] = group
    end
    
    if (@current_category)
      @label_templates = @label_groups[@current_category]
    end
    @label_templates = Kaminari.paginate_array(@label_templates).page(params[:page]).per(Spree::Config.products_per_page) 
  end
end
