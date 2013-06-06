class SetupDefaultBlendableTaxons < ActiveRecord::Migration
  def up
    # make sure Categories exists
    categories = Spree::Taxonomy.find_by_name("Categories")
    if (categories == nil)
      categories = Spree::Taxonomy.new
      categories.name = "Categories"
      categories.position = 0
      if !categories.save 
        raise "Failed to save Categories taxonomy!"
      end
    end
    
    #now check for Categories taxon
    categories_taxon = Spree::Taxon.find_by_taxonomy_id(categories.id)
    if (categories_taxon == nil)
      categories_taxon = Spree::Taxon.new
      categories_taxon.name = "Categories"
      categories_taxon.permalink = "categories"
      categories_taxon.taxonomy_id = categories.id
      categories_taxon.position = 0
      if !categories_taxon.save 
        raise "Failed to save Categories taxon!"
      end
    end
    
    # setup black tea    
    black_tea = Spree::Taxon.find_by_name("Black Tea")
    if (black_tea == nil)
      black_tea = Spree::Taxon.new
      black_tea.name = "Black Tea"
      black_tea.permalink = "categories/black-tea"
      black_tea.parent_id = categories_taxon.id
      black_tea.taxonomy_id = categories.id
      black_tea.position = 0
      if !black_tea.save 
        raise "Failed to save Black Tea taxon!"
      end
    end
    black_tea_blendable_taxon = Spree::BlendableTaxon.create(:taxon_id => black_tea.id)
    
    # setup fruit tea
    fruit_tea = Spree::Taxon.find_by_name("Fruit Tea")
    if (fruit_tea == nil)
      fruit_tea = Spree::Taxon.new
      fruit_tea.name = "Fruit Tea"
      fruit_tea.permalink = "categories/fruit-tea"
      fruit_tea.parent_id = categories_taxon.id
      fruit_tea.taxonomy_id = categories.id
      fruit_tea.position = 1
      if !fruit_tea.save 
        raise "Failed to save Fruit Tea taxon!"
      end
    end
    fruit_tea_blendable_taxon = Spree::BlendableTaxon.create(:taxon_id => fruit_tea.id)
    
    # setup herbal tea
    herbal_tea = Spree::Taxon.find_by_name("Herbal Tea")
    if (herbal_tea == nil)
      herbal_tea = Spree::Taxon.new
      herbal_tea.name = "Herbal Tea"
      herbal_tea.permalink = "categories/green-tea"
      herbal_tea.parent_id = categories_taxon.id
      herbal_tea.taxonomy_id = categories.id
      herbal_tea.position = 1
      if !herbal_tea.save 
        raise "Failed to save Green Tea taxon!"
      end
    end
    herbal_tea_blendable_taxon = Spree::BlendableTaxon.create(:taxon_id => herbal_tea.id)
    
    # setup green tea
    green_tea = Spree::Taxon.find_by_name("Green Tea")
    if (green_tea == nil)
      green_tea = Spree::Taxon.new
      green_tea.name = "Green Tea"
      green_tea.permalink = "categories/green-tea"
      green_tea.parent_id = categories_taxon.id
      green_tea.taxonomy_id = categories.id
      green_tea.position = 1
      if !green_tea.save 
        raise "Failed to save Green Tea taxon!"
      end
    end
    green_tea_blendable_taxon = Spree::BlendableTaxon.create(:taxon_id => green_tea.id)
     
    # setup white tea
    white_tea = Spree::Taxon.find_by_name("White Tea")
    if (white_tea == nil)
      white_tea = Spree::Taxon.new
      white_tea.name = "White Tea"
      white_tea.permalink = "categories/white-tea"
      white_tea.parent_id = categories_taxon.id
      white_tea.taxonomy_id = categories.id
      white_tea.position = 1
      if !white_tea.save 
        raise "Failed to save Fruit Tea taxon!"
      end
    end
    white_tea_blendable_taxon = Spree::BlendableTaxon.create(:taxon_id => white_tea.id)
  
  end
  
  def down 
    
  end
end
  