module Spree
  class ImagesController < Spree::ResourceController
    include Spree::Core::ControllerHelpers::Order
    before_filter :load_data

    create.before :set_viewable
    update.before :set_viewable
    destroy.before :destroy_before

    def update_positions
      params[:positions].each do |id, index|
        Image.where(:id => id).update_all(:position => index)
      end

      respond_to do |format|
        format.js  { render :text => 'Ok' }
      end
    end

    def update
      logger.debug("**************** in Update")
      #clear this first so that it is only set if the user is using a remote image right now
      @object.label_image_remote_url = ""

      if @object.update_attributes(params[:image])
        respond_with(@object) do |format|
          format.html do
            redirect_to edit_product_url(@product)
          end
        end
      else
        respond_with(@object)
      end
    end

    private

    def location_after_save
      edit_product_url(@product)
    end

    def load_data
      @product = Product.find_by_permalink(params[:product_id])
      @variants = @product.variants.collect do |variant|
            [variant.options_text, variant.id]
          end
      @variants.insert(0, [I18n.t(:all), 'All'])

      @current_category = params[:c]
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
    #@label_templates = Kaminari.paginate_array(@label_templates).page(params[:page]).per(Spree::Config.products_per_page)
    end

    def set_viewable
      logger.debug("****************  set_viewable")
      if params[:label_image_remote_url].nil? and params[:image].has_key? :viewable_id
        if params[:image][:viewable_id] == 'All'
          @object.viewable = @product.master
          @object.viewable_id = @product.master.id
          logger.debug("********** 1 viewable_id = " + (@object.viewable_id.blank? ? "nil" : @object.viewable_id.to_s))
        else
          @object.viewable_type = 'Spree::Variant'
          @object.viewable_id = params[:image][:viewable_id]
          logger.debug("********** 2 viewable_id = " + (@object.viewable_id.blank? ? "nil" : @object.viewable_id.to_s))
        end
      else
        @object.viewable = @product.master
        @object.viewable_id = @product.master.id
        logger.debug("********** 3 viewable_id = " + (@object.viewable_id.blank? ? "nil" : @object.viewable_id.to_s))
      end
    end

    def destroy_before
      @viewable = @image.viewable
    end

  end
end
