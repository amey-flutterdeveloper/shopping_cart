import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart'as badges;
import 'package:shopping_cart/cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(backgroundColor: Colors.deepPurple,
      title: const Text('My Products',
      style: TextStyle(color: Colors.white),),
      centerTitle: true,
      actions: [
        Center(
          child: badges.Badge(badgeContent:Consumer<CartProvider>(
              builder: (context,value,child){
            return Text(value.getCounter().toString(),
              style: TextStyle(color: Colors.white),);}) ,

            child: const Icon(Icons.shopping_bag_outlined,
                color: Colors.white),
          ),
        ),
        const SizedBox(width: 20.0),
      ],
    ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    image: NetworkImage(snapshot.data![index].image.toString()),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(

                                          children: [
                                          Text(
                                            snapshot.data![index].productName.toString(),
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          InkWell(child: Icon(Icons.delete,color: Colors.red,),
                                          onTap: (){
                                          dbHelper!.delete(snapshot.data![index].id!);
                                          cart.removeCounter();
                                          cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                          },)
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,),

                                        const SizedBox(height: 5),
                                        Text(
                                          snapshot.data![index].unitTag.toString() +
                                              " " +
                                              r"$" +
                                              snapshot.data![index].productPrice.toString(),
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Add to Cart',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(child: Text("Loading..."));
              }
            },
          ),
          Consumer<CartProvider>(builder: (context,value,child){

            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
              child: Column(
              children: [
                ReusableWidget(title: 'Sub Total', value:r'$'+value.getTotalPrice().toStringAsFixed(2))
              ],
                        ),
            );})

        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.titleMedium,),
          Text(value.toString(),style: Theme.of(context).textTheme.titleMedium,)
        ],),
    );
  }
}