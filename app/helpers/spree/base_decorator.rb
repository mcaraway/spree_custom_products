Spree::Core::Search::Base.class_eval do
  def prepare(params)
    @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])
    @properties[:keywords] = params[:keywords]
    @properties[:search] = params[:search]
    @properties[:ispublic] = params[:ispublic]
    @properties[:isfinal] = params[:isfinal]

    per_page = params[:per_page].to_i
    @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
    @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
  end
  
  def add_search_scopes(base_scope)
    search.each do |name, scope_attribute|
      scope_name = name.to_sym
      if base_scope.respond_to?(:search_scopes) && base_scope.search_scopes.include?(scope_name.to_sym)
        base_scope = base_scope.send(scope_name, *scope_attribute)
      else
        base_scope = base_scope.merge(Spree::Product.search({scope_name => scope_attribute}).result)
      end
    end if search
    base_scope = base_scope.ispublic(ispublic)
    base_scope = base_scope.isfinal(isfinal)
    base_scope
  end
end
