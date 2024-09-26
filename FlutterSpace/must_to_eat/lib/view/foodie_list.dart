import 'package:flutter/material.dart';
import 'package:must_to_eat/view/user.dart';
import 'add_list.dart';
import 'edit_list.dart';
import 'detail.dart';
import 'package:get/get.dart';

class FoodieList extends StatefulWidget {
  const FoodieList({super.key});

  @override
  State<FoodieList> createState() => _FoodieListState();
}

class _FoodieListState extends State<FoodieList> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> stores = [];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  void _loadDummyData() {
    stores = List.generate(
      10,
      (index) => {
        'id': index + 1,
        'name': '맛집 ${index + 1}',
        'phone': '010-1234-${5670 + index}',
        'image': 'images/placeholder.png',
        'latitude': 37.5 + index * 0.01,
        'longitude': 127.0 + index * 0.01,
        'rating': (3 + index % 3).toDouble(),
      },
    );
    setState(() {});
  }

  void _searchStores(String query) {
    setState(() {
      if (query.isEmpty) {
        _loadDummyData();
      } else {
        stores = stores
            .where((store) =>
                store['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _deleteStore(int id) {
    setState(() {
      stores.removeWhere((store) => store['id'] == id);
    });
    // 여기에 서버 삭제 로직 추가 예정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const AddList()),
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
                                    Get.to(() =>
                                            Detail(storeData: stores[index]))
                                        ?.then((_) => _loadDummyData());
                                  },
                                  child: Image.asset(
                                    stores[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  stores[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Rating: ${stores[index]['rating']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() =>
                                          EditList(storeData: stores[index]))
                                      ?.then((_) => _loadDummyData());
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
                              onPressed: () =>
                                  _deleteStore(stores[index]['id']),
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
