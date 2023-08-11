import 'package:cute/constant/constant.dart';
import 'package:cute/pages/courier/restaurant_items.dart';
import 'package:flutter/material.dart';

class GetFoodDeliver extends StatefulWidget {
  @override
  _GetFoodDeliverState createState() => _GetFoodDeliverState();
}

class _GetFoodDeliverState extends State<GetFoodDeliver> {
  final restaurantsList = [
    {
      'title': 'Bar 61 Restaurant',
      'type': 'Beverages, Snacks',
      'address': '76A England',
      'image': 'assets/restaurant/restaurant_5.png',
      'time': '15 mins',
      'deliverey': 'Free Delivery',
      'offer': '20% off upto \$2'
    },
    {
      'title': 'Core by Clare Smyth',
      'type': 'Beverages, Fast Food',
      'address': '220 Opera Street',
      'image': 'assets/restaurant/restaurant_4.png',
      'time': '20 mins',
      'deliverey': '',
      'offer': ''
    },
    {
      'title': 'Amrutha Lounge',
      'type': 'Full Meal',
      'address': '90B Silicon Velley',
      'image': 'assets/restaurant/restaurant_3.png',
      'time': '25 mins',
      'deliverey': 'Free Delivery',
      'offer': '25% off on order above \$5'
    },
    {
      'title': 'The Barbary',
      'type': 'Desserts',
      'address': '99C OBC Area',
      'image': 'assets/restaurant/restaurant_2.png',
      'time': '28 mins',
      'deliverey': 'Free Delivery',
      'offer': '20% off upto \$3'
    },
    {
      'title': 'The Palomar',
      'type': 'American Fastfood',
      'address': '31A Om Colony',
      'image': 'assets/restaurant/restaurant_1.png',
      'time': '15 mins',
      'deliverey': 'Free Delivery',
      'offer': '15% off upto \$5'
    },
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Hero(
      tag: 'Get Food Deliver',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 1.0,
          titleSpacing: 0.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Restaurants', style: appBarTextStyle),
              Text('285 Stores', style: greySmallTextStyle),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: blackColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: restaurantsList.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = restaurantsList[index];
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RestaurantItems()));
              },
              child: Container(
                width: width,
                margin: (index == 0)
                    ? EdgeInsets.all(fixPadding * 2.0)
                    : EdgeInsets.only(
                        right: fixPadding * 2.0,
                        left: fixPadding * 2.0,
                        bottom: fixPadding * 2.0),
                padding: EdgeInsets.all(fixPadding),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      item['image']!,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.fitHeight,
                    ),
                    widthSpace,
                    Container(
                      width: (width - (fixPadding * 6.0 + 10.0 + 100.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: appBarBlackTextStyle,
                          ),
                          Text(item['type']!,
                              style: primaryColorSmallTextStyle),
                          Text(item['address']!, style: inputTextStyle),
                          const SizedBox(height: 3.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.timer,
                                  color: primaryColor, size: 18.0),
                              const SizedBox(width: 5.0),
                              Text(
                                (item['deliverey'] != '')
                                    ? '${item['time']}, ${item['deliverey']}'
                                    : '${item['time']} delivery',
                                style: TextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                          (item['offer'] != '')
                              ? const SizedBox(height: 5.0)
                              : Container(),
                          (item['offer'] != '')
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.local_offer,
                                        color: Colors.deepPurple, size: 18.0),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      item['offer']!,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
