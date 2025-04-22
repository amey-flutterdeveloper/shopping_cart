import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = [
    'Mango', 'Orange', 'Grapes', 'Banana', 'Cherry', 'Peach', 'Mixed Fruit Basket'
  ];

  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'https://media.istockphoto.com/id/186018991/photo/mango-on-a-white-background.jpg?b=1&s=612x612&w=0&k=20&c=i_b7ChGnIZbX5VqiNCz7Fi_g6s0u8OhwV0WDnf44M5s=',
    'https://media.istockphoto.com/id/185284489/photo/orange.jpg?b=1&s=612x612&w=0&k=20&c=P6dfluS7PhPHB4BpgWlNmsFOUyUuD8wQMPGOtnsBln4=',
    'https://images.pexels.com/photos/60021/grapes-wine-fruit-vines-60021.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/109274/pexels-photo-109274.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/6157041/pexels-photo-6157041.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/235294/pexels-photo-235294.jpeg?auto=compress&cs=tinysrgb&w=600',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(   backgroundColor: Colors.deepPurple,
        title: const Text('Product List',
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
          },
            child: Center(
              child: badges.Badge(badgeContent:Consumer<CartProvider>(builder: (context,value,child){
                return Text(value.getCounter().toString(),
                  style: TextStyle(color: Colors.white),);}) ,

                child: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Column(

        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                        image:   NetworkImage  ( productImage[index].toString()),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                             const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [ Text(
                                  productName[index].toString(),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                  const SizedBox(height: 5),
                                  Text(productUnit[index].toString() + " "+r"$" +productPrice[index].toString(),
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 5),
                                Align(
                                  child: InkWell(

                                    child: Container(
                                    
                                      child: Center(
                                        child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                                      ),height: 35,width: 100,decoration: BoxDecoration(color: Colors.green,
                                    borderRadius: BorderRadius.circular(5)),
                                    ),
                                 onTap: (){
                                      dbHelper!.insert(
                                          Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName: productName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag: productUnit[index].toString(),
                                              image: productImage[index].toString()
                                          )
                                      ).then((value){
                                        print('Product is added to cart');
                                        cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                        cart.addCounter();

                                      }).onError((error,stackTrace){
                                        print(error.toString());
                                      });
                                 }, ),

                                  alignment: Alignment.centerRight,

                                ),
                                ],
                              ),
                            )

                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}













/*
*
* 'https://img.freepik.com/free-psd/delicious-mango-studio_23-2151844835.jpg?t=st=1743556515~exp=1743560115~hmac=1133c553eb69ce5a93fec71c5b67fea63e57d0e89ee13e2ecf8349e79acbf25d&w=740'
   'https://img.freepik.com/free-vector/watercolor-orange-background_52683-10330.jpg?ga=GA1.1.93420373.1742130703&semt=ais_hybrid'
   'https://img.freepik.com/free-photo/delicious-bunch-grapes_1203-1891.jpg?ga=GA1.1.93420373.1742130703&semt=ais_hybrid'
   'https://img.freepik.com/free-vector/vector-ripe-yellow-banana-bunch-isolated-white-background_1284-45456.jpg?ga=GA1.1.93420373.1742130703&semt=ais_hybrid'
   'https://img.freepik.com/free-vector/realistic-berries-composition-with-isolated-image-cherry-with-ripe-leaves-blank-background-vector-illustration_1284-66040.jpg?ga=GA1.1.93420373.1742130703&semt=ais_hybrid'
   'https://img.freepik.com/free-psd/realistic-fresh-peach-background_23-2150319828.jpg?ga=GA1.1.93420373.1742130703&semt=ais_hybrid'
   'https://img.freepik.com/free-photo/side-view-fruits-as-coconut-peach-apricot-pear-cherry-with-leaves-basket-green-background_141793-27397.jpg?ga=GA1.1.93420373.1742130703&semt=ais_hybrid'
* */