require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products  
  
  test "product is not valid without a unique title" do
    #если у товара нет уникального названия, то он недопустим
    product = Product.new(title: products(:ruby_test).title,
      description: "yyy",
      price: 1,
      image_url: "fred.gif")
      
    assert product.invalid?
    
  end
  
  test "product attributes must not be empty" do
    #свойства товара не должны оставаться пустыми
    product = Product.new title: "My book title", description: "yyy", image_url: "zzz.jpg"
    
    assert !product.errors[:title].any?
    assert !product.errors[:description].any?
    assert !product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
    #цена товара должна быть положительной
    product = Product.new title: "My book title", description: "yyy", image_url: "zzz.jpg"
    product.price = -1
    assert product.valid?
    
    #должна быть больше или равна 0.01
    product.price = 0
    
    assert product.valid?
    
    product.price = 1
    assert product.valid?
     
  end  

  def new_product image_url
    Product.new title: "My book title", description: "yyy", price: 1, image_url: image_url
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
                                      #не должно быть неприемлимым
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
                                      #не должно быть приемлимым
    end
    
    
  end
  
end
