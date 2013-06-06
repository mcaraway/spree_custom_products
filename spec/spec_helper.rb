# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'
require 'ffaker'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

require 'database_cleaner'

# Requires factories defined in spree_core
require 'spree/core/testing_support/factories'
require 'spree/core/testing_support/controller_requests'
require 'spree/core/testing_support/authorization_helpers'
require 'spree/core/testing_support/capybara_ext'
require 'spree/core/testing_support/preferences'
require 'spree/core/testing_support/flash'
require 'spree/core/url_helpers'
require 'paperclip/matchers'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # == URL Helpers
  #
  # Allows access to Spree's routes in specs:
  #
  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::Core::UrlHelpers

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
    reset_spree_preferences
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::Core::UrlHelpers
  config.include Spree::Core::TestingSupport::ControllerRequests
  config.include Spree::Core::TestingSupport::Preferences
  config.include Spree::Core::TestingSupport::Flash

  config.include Paperclip::Shoulda::Matchers
end

shared_context "custom products" do
  before(:each) do
    configure_spree_preferences do |config|
      config.allow_backorders = true
    end

    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Categories')
    root = taxonomy.root
    clothing_taxon = FactoryGirl.create(:taxon, :name => 'Clothing', :parent_id => root.id)
    bags_taxon = FactoryGirl.create(:taxon, :name => 'Bags', :parent_id => root.id)
    mugs_taxon = FactoryGirl.create(:taxon, :name => 'Mugs', :parent_id => root.id)

    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Brands')
    root = taxonomy.root
    apache_taxon = FactoryGirl.create(:taxon, :name => 'Apache', :parent_id => root.id)
    rails_taxon = FactoryGirl.create(:taxon, :name => 'Ruby on Rails', :parent_id => root.id)
    ruby_taxon = FactoryGirl.create(:taxon, :name => 'Ruby', :parent_id => root.id)

    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Ringer T-Shirt', :price => '19.99', :taxons => [rails_taxon, clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Mug', :price => '15.99', :taxons => [rails_taxon, mugs_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Tote', :price => '15.99', :taxons => [rails_taxon, bags_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Bag', :price => '22.99', :taxons => [rails_taxon, bags_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Baseball Jersey', :price => '19.99', :taxons => [rails_taxon, clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Stein', :price => '16.99', :taxons => [rails_taxon, mugs_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Jr. Spaghetti', :price => '19.99', :taxons => [rails_taxon, clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby Baseball Jersey', :price => '19.99', :taxons => [ruby_taxon, clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Apache Baseball Jersey', :price => '19.99', :taxons => [apache_taxon, clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Public Product', :public => true, :price => '19.99', :taxons => [apache_taxon, clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Private Product', :public => false, :price => '19.99', :taxons => [apache_taxon, clothing_taxon])
  end
end