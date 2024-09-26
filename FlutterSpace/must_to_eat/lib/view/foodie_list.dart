import 'package:flutter/material.dart';
import 'package:must_to_eat/view/user.dart';
import 'package:must_to_eat/vm/list_handler.dart';
import 'add_list.dart';
import 'edit_list.dart';
import 'detail.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FoodieList extends StatefulWidget {
  const FoodieList({super.key});

  @override
  State<FoodieList> createState() => _FoodieListState();
}

class _FoodieListState extends State<FoodieList> {
  final TextEditingController _searchController = TextEditingController();
  final ListHandler handler = ListHandler();
  List<dynamic> stores = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    stores.clear();
    List<dynamic> temp = await handler.queryJSONData();
    stores.addAll(temp);
    setState(() {});
  }

  void _searchStores(String query) {
    setState(() {
      if (query.isEmpty) {
        getData();
      } else {
        // Implement search functionality here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const AddList())!.then(
          (value) => getData(),
        ),
        backgroundColor: const Color(0xffFBB816),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.add_outlined),
      ),
      appBar: AppBar(
        title: const Text(
          'Foodie List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffFBB816),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                Get.to(() => const User());
              },
              icon: const Icon(
                Icons.person_2_rounded,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchStores,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFBB816)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFBB816)),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/back.png',
                    fit: BoxFit.cover,
                  ),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Implement navigation to detail page
                                  },
                                  child: Image.network(
                                    'http://127.0.0.1:8000/must_eat/view/${stores[index].image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  stores[index].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: RatingBarIndicator(
                                  rating: stores[index].rankPoint,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Implement navigation to edit page
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                // Implement delete functionality
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}