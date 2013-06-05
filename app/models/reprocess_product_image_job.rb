# encoding: utf-8
require 'net/http'

class Spree::ReprocessProductImageJob < Struct.new(:product_id)
  def perform
    product = Spree::Product.find(self.product_id)
    return unless product != nil
    
    url = generate_file_name(product)

    if !validate_uri_existence_of(url)
      puts "*************** url not found: " + url
    end
    image = product.images.blank? ? Spree::Image.new : product.images[0]

    image.viewable_type = 'Spree::Variant'
    image.viewable_id = product.master.id
    image.alt = product.name
    image.download_image(url)
    image.save!
  end

  # encoding: utf-8
  def generate_file_name(product)
    cleaned_name = product.name.downcase.rstrip
    cleaned_name = cleaned_name.sub("w/","with").tr(" / ", "-").tr("/","-").tr(" - ", "-").tr(" ", "-")
    cleaned_name = cleaned_name.sub("&","and").sub("---","-")
    cleaned_name = cleaned_name.sub("'","").sub("?","").sub(".","")

    # encoding: utf-8
    character_table = {'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
      'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
      'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
      'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
      'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
      'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
      'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f'}
    regexp_keys = Regexp.union(character_table.keys)
    cleaned_name = cleaned_name.gsub(regexp_keys, character_table)

    url = "http://s3.amazonaws.com/uniqteas/images/products/#{cleaned_name}.jpg"
    url
  end

  def validate_uri_existence_of(url)
    begin # check header response
      case Net::HTTP.get_response(URI.parse(url))
      when Net::HTTPSuccess then true
      else  false
      end
    rescue # Recover on DNS failures..
    false
    end
  end
end