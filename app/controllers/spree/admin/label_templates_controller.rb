module Spree
  module Admin
    class LabelTemplatesController < Spree::Admin::ResourceController
      before_filter :load_data
      def refresh_labels
        Delayed::Job.enqueue Spree::ReprocessLabelTemplatesJob.new(1)
        respond_to do |format|
          format.html { redirect_to location_after_save }
          format.js   { render :layout => false }
        end
      end

      def reprocess_images
        Delayed::Job.enqueue Spree::ReprocessImagesJob.new(1)

        respond_to do |format|
          format.html { redirect_to admin_products_url }
          format.js   { render :layout => false }
        end
      end

      protected

      def location_after_save
        admin_label_templates_url
      end

      private

      def load_data
        #@label_template = Spree::LabelTemplate.find_by_id(params[:id])

        @label_templates = Spree::LabelTemplate.all
        @label_groups = Hash.new
        @label_templates.each do |template|
          group = @label_groups[template.group]
          group = group == nil ? [] : group
          group << template
          @label_groups[template.group] = group
        end
      end
    end
  end
end