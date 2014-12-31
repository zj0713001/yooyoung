class Main::HomeController < Main::ApplicationController
  layout 'main/home'
  def index
    @title = '主站首页'

    # Test
    @banner_data = [
      {
        image: "http://git-sipc.qiniudn.com/yooyoung-01.jpg",
        package_name: 'Camelia花园套餐',
        package_price: '5888',
        hotel_name: '1巴黎文华东方酒店',
        hotel_location: '法国巴黎',
      },
      {
        image: "http://git-sipc.qiniudn.com/yooyoung-02.jpg",
        package_name: 'Exterior_and_Garden',
        package_price: '6888',
        hotel_name: '2济州凯悦酒店',
        hotel_location: '韩国济州岛',
      },
      {
        image: "http://git-sipc.qiniudn.com/yooyoung-03.jpg",
        package_name: 'Private_Dining_on_the_Beach',
        package_price: '8888',
        hotel_name: '3马尔代夫柏悦酒店',
        hotel_location: '马尔代夫王子岛',
      },
    ]

    @section_data = [
      {
        image: "http://git-sipc.qiniudn.com/section-01.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '1曼谷文化东方酒店',
        hotel_location: '泰国，曼谷',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-02.jpg",
        type: :hotel,
        view: :'big-square',
        hotel_name: '2香格里拉斐济度假酒店',
        hotel_location: '斐济',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-03.jpg",
        type: :hotel,
        view: :vertical,
        hotel_name: '3Hyatt Paris Madeleine',
        hotel_location: '法国，巴黎',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-04.jpg",
        type: :area,
        view: :'small-square',
        area_name: '斐济',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-05.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '5香格里拉台北国际大饭店',
        hotel_location: '台湾，台北',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-06.jpg",
        type: :area,
        view: :'small-square',
        area_name: '苏梅岛',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-07.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '7长春凯悦酒店',
        hotel_location: '吉林，长春',
      },
      {
        image: "http://git-sipc.qiniudn.com/section-08.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '8裸心谷',
        hotel_location: '浙江，莫干山',
      },
    ]
  end
end
