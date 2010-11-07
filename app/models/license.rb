class License <  ActiveRecord::Base
  acts_as_document
end

#class Product < ActiveRecord::Base
#  self.abstract_class = true
#  has_one :product_properties, :as => :product, :dependent => :destroy
#  delegate :price, :price=, :name, :name=, :description, :description=, :to => :product_properties
#  def product_properties_with_autobuild
#    product_properties_without_autobuild || build_product_properties
#  end
#  alias_method_chain :product_properties, :autobuild
#end
