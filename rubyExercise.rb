require 'nokogiri'
require 'open-uri'
require 'json'


# Define Apartment class.
class Apartment
	attr_accessor :listing_class, :address, :unit, :id, :price
	def initialize(listing_class, address, unit, id, price)
		@listing_class=listing_class
		@address=address
		@unit=unit
		@id=id
		@price=price
	end
end


# Implement the method getInfo to get the required attributes from dataLayer.
def getInfo (data)
	id = data.split(",\"price\":")
	price = id[1].split(",\"bedrooms\"")	
	temp = price[1].split("\"addr_street\":\"")
	address = temp[1].split("\",\"addr_unit\":\"")
	unit = address[1].split("\",\"addr_hood\":\"")	
	info = Array[address[0], unit[0], id[0], price[0]]
end


# Get dataLayer from urls by using Nokogiri.
url_sell = 'http://streeteasy.com/for-sale/soho?view=list&sort_by=price_desc'
url_rental = 'http://streeteasy.com/for-rent/soho?view=list&sort_by=price_desc'
doc_sell = Nokogiri::HTML(open( url_sell ))
doc_rental = Nokogiri::HTML(open( url_rental ))
dataLayer_sell = doc_sell.xpath("//script")[7].text.split("\":{\"id\":")
dataLayer_rental = doc_rental.xpath("//script")[7].text.split("\":{\"id\":")


# Create 2 object arrays (apts_sell & apts_rental) to store Apartment objects.
apts_sell = Array.new(20)
apts_rental = Array.new(20)
info_sell = getInfo(dataLayer_sell[i + 1])
info_rental = getInfo(dataLayer_rental[i + 1])
for i in 0..19
	apts_sell[i] = Apartment.new("Sale", info_sell[0], info_sell[1], info_sell[2], info_sell[3])
	apts_rental[i] = Apartment.new("Rental", info_rental[0], info_rental[1], info_rental[2], info_rental[3])
end


# Create output.json file and write the information from apts_sell & apts_rental.
file = File.new("./output.json", "w")
file.syswrite("[")
for i in 0..19
	file.syswrite("{\n")
	file.syswrite("\t\"listing_class\": \"" + apts_sell[i].listing_class + "\",\n")
	file.syswrite("\t\"address\": \"" + apts_sell[i].address + "\",\n")
	file.syswrite("\t\"unit\": \"" + apts_sell[i].unit + "\",\n")
	file.syswrite("\t\"url\": \"http://streeteasy.com/nyc/sale/" + apts_sell[i].id + "\",\n")
	file.syswrite("\t" + "\"price\": " + apts_sell[i].price + "\n")
	file.syswrite("},")
end
for i in 0..19
	file.syswrite("{\n")
	file.syswrite("\t\"listing_class\": \"" + apts_rental[i].listing_class + "\",\n")
	file.syswrite("\t\"address\": \"" + apts_rental[i].address + "\",\n")
	file.syswrite("\t\"unit\": \"" + apts_rental[i].unit + "\",\n")
	file.syswrite("\t\"url\": \"http://streeteasy.com/nyc/rental/" + apts_rental[i].id + "\",\n")
	file.syswrite("\t\"price\": " + apts_rental[i].price + "\n")	
	file.syswrite("}")
	if (i < 19) then file.syswrite(",") end
end
file.syswrite("]")
file.close
