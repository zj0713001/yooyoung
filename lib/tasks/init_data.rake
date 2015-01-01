namespace :areas do
  desc '初始化导入国家和城市'
  task import_countries_and_cities: :environment do
    location_doc = Crack::XML.parse(File.read(File.join(Rails.root, 'lib', 'data', 'LocList.xml')))
    location_doc['Location']['CountryRegion'].each do |country_doc|
      country = Country.find_or_create_by(chinese: country_doc['Name']) do |country|
        country.name = "country_#{country_doc['Code']}"
        country.code = country_doc['Code']
      end
      if country_doc['State'].is_a? Hash
        country_doc['State']['City'].each do |city_doc|
          City.find_or_create_by(chinese: city_doc['Name'], country_id: country.id) do |city|
            city.name = "city_#{city_doc['Code']}"
            city.code = city_doc['Code']
          end
        end
      end
      if country_doc['State'].is_a? Array
        country_doc['State'].each do |province_doc|
          province = Province.find_or_create_by(chinese: province_doc['Name'], country_id: country.id) do |province|
            province.name = "province_#{province_doc['Code']}"
            province.code = province_doc['Code']
          end
          if province_doc['City'].is_a? Hash
            city_doc = province_doc['City']
            City.find_or_create_by(chinese: city_doc['Name'], country_id: country.id, province_id: province.id) do |city|
              city.name = "city_#{city_doc['Code']}"
              city.code = city_doc['Code']
            end
          end
          if province_doc['City'].is_a? Array
            province_doc['City'].each do |city_doc|
              City.find_or_create_by(chinese: city_doc['Name'], country_id: country.id, province_id: province.id) do |city|
                city.name = "city_#{city_doc['Code']}"
                city.code = city_doc['Code']
              end
            end
          end
        end
      end
    end
  end
end
