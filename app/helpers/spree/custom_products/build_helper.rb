module Spree::CustomProducts::BuildHelper
    def build_progress
      items = wizard_steps.map do |s|    
        text = s.to_s.titleize

        css_classes = []
        
        badge_classes = []
        badge_classes << 'badge'
        current_index = wizard_steps.index(step)
        s_index = wizard_steps.index(s)

        if s_index < current_index
          css_classes << 'completed'
          badge_classes << 'badge-success'
          text = link_to text, wizard_path(s)
        end

        css_classes << 'next' if s_index == current_index + 1
        css_classes << 'current' if s == step
        css_classes << 'last' if s_index == wizard_steps.length - 1
        badge_classes << 'badge-info' if s == step
        badge_number = s_index + 1
        # It'd be nice to have separate classes but combining them with a dash helps out for IE6 which only sees the last class
        content_tag('li', content_tag('span', badge_number.to_s, :class => badge_classes.join(' ')) + content_tag('span', text) + content_tag('span', '', :class => 'chevron'), :class => css_classes.join('-'))
      end
      content_tag('ul', raw(items.join("\n")), :class => 'progress-steps', :id => "checkout-step-#{step}")
    end   
end