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
        hotel_name: '巴黎文华东方酒店',
        hotel_location: '法国巴黎',
      },
      {
        image: "http://git-sipc.qiniudn.com/yooyoung-02.jpg",
        package_name: 'Exterior_and_Garden',
        package_price: '16888',
        hotel_name: '济州凯悦酒店',
        hotel_location: '韩国济州岛',
      },
      {
        image: "http://git-sipc.qiniudn.com/yooyoung-03.jpg",
        package_name: 'Private_Dining_on_the_Beach',
        package_price: '228888',
        hotel_name: '马尔代夫柏悦酒店',
        hotel_location: '马尔代夫王子岛',
      },
    ]

    @section_data = [
      {
        image: "http://git-sipc.qiniudn.com/section01.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '曼谷文化东方酒店',
        hotel_location: '泰国，曼谷',
      },
      {
        image: "http://git-sipc.qiniudn.com/section02.jpg",
        type: :hotel,
        view: :'big-square',
        hotel_name: '香格里拉斐济度假酒店',
        hotel_location: '斐济',
      },
      {
        image: "http://git-sipc.qiniudn.com/section03.jpg",
        type: :hotel,
        view: :vertical,
        hotel_name: 'Hyatt Paris Madeleine',
        hotel_location: '法国，巴黎',
      },
      {
        image: "http://git-sipc.qiniudn.com/section04.jpg",
        type: :area,
        color: :yellow,
        view: :'small-square',
        area_name: '斐济',
      },
      {
        image: "http://git-sipc.qiniudn.com/section05.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '香格里拉台北国际大饭店',
        hotel_location: '台湾，台北',
      },
      {
        image: "http://git-sipc.qiniudn.com/section06.jpg",
        type: :area,
        color: :green,
        view: :'small-square',
        area_name: '苏梅岛',
      },
      {
        image: "http://git-sipc.qiniudn.com/section07.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '长春凯悦酒店',
        hotel_location: '吉林，长春',
      },
      {
        image: "http://git-sipc.qiniudn.com/section08.jpg",
        type: :hotel,
        view: :horizontal,
        hotel_name: '裸心谷',
        hotel_location: '浙江，莫干山',
      },
    ]
  end
end
