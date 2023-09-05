import 'package:flutter/material.dart';

import '../galleries/bags_gallery.dart';
import '../galleries/home_garden_gallery.dart';
import '../galleries/men_gallery.dart';
import '../galleries/shoes_gallery.dart';
import '../galleries/women_gallery.dart';
import '../galleries/electronics_gallery.dart';
import '../galleries/access_gallery.dart';
import '../my_widgets/search_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(.5),
        appBar: AppBar(
          // centerTitle: true,
          title: const SearchBoxAppBar(),
          //,
          elevation: 0,
          bottom: const TabBar(isScrollable: true, tabs: [
            RepeatedTab(
              tabName: 'Men',
            ),
            RepeatedTab(tabName: 'Women'),
            RepeatedTab(tabName: 'Shoes'),
            RepeatedTab(tabName: 'Bags'),
            RepeatedTab(tabName: 'Electronics'),
            RepeatedTab(tabName: 'Accessories'),
            RepeatedTab(tabName: 'Home & Garden'),
            RepeatedTab(tabName: 'Kids'),
            RepeatedTab(tabName: 'Beauty')
          ]),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              MenGalleryScreen(),
              WomenGalleryScreen(),
              ShoesGalleryScreen(),
              BagsGalleryScreen(),
              ElectronicsGalleryScreen(),
              AccessoriesGalleryScreen(),
              HomeGardenGalleryScreen(),
              Center(child: Text('Text from Tab Eight')),
              Center(child: Text('Text from Tab Nine'))
            ],
          ),
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String tabName;

  /// ye Icons lene se appBar ke title ki symmetry mein bahut difference aata hai;
  /// sb kuch trial krke ke baad isko deactivate kr diya.
  ///

  //final IconData? iconName;

  const RepeatedTab({
    super.key,
    required this.tabName,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: tabName,

      // icon: Icon(iconName),
    );
  }
}
