import 'package:chawla_trial_udemy/categories/bags_categ.dart';
import 'package:chawla_trial_udemy/categories/home_and_garden_categ.dart';
import 'package:chawla_trial_udemy/categories/shoes_categ.dart';
import 'package:chawla_trial_udemy/categories/women_categ.dart';
import 'package:chawla_trial_udemy/my_widgets/search_box.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../categories/accessories_categ.dart';
import '../categories/beauty_categ.dart';
import '../categories/electronics_categ.dart';
import '../categories/kids_categ.dart';
import '../categories/men_categ.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  PageController _pageController = PageController();
  List<ItemData> sampleList = [
    ItemData(label: 'men'),
    ItemData(label: 'women'),
    ItemData(label: 'shoes'),
    ItemData(label: 'bags'),
    ItemData(label: 'electronics'),
    ItemData(label: 'accessories'),
    ItemData(label: 'home & garden'),
    ItemData(label: 'kids'),
    ItemData(label: 'beauty'),
  ];

  bool selectedContainer = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
/** full method ko samajhne ke liye, sideNavigator aur categView ko
 * sahi se with comments read kro, samjho.
 */
    for (var element in sampleList) {
      element.isSelected = false;
    }

    setState(() {
      sampleList[0].isSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    /** Size type variables ko context ke ander hi define krna hota hai. other variables
     * ki tarah bahar nahi. */
    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const SearchBoxAppBar(),
      ),
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: sideNavigator(_size),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: categView(_size),
          )
        ]),
      ),
    );
  }

  Widget sideNavigator(Size _size) {
    return SizedBox(
      height: _size.height * .8,
      width: _size.width * .2,
      child: ListView.builder(
        itemCount: sampleList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.jumpToPage(index);
              /** pageController ko sideNavigator se control krte
               * hi niche wale code ko chahe to dead krdo, lekin
               * usko pageView mein active rakha hua hai for the same
               * usage */

              // tap krte hi baki sbki values ko fir se false ke dega lekin
              // setState mein selected ko true rakhega.
              // isse gesture Detector mein tapping kkr
              // kuch bhi kr skte hin, like humne sirf color change kiya.

              /**
                2. for (var element in sampleList) {
                  element.isSelected = false;
                  }

                1.   setState(() {
                  sampleList[index].isSelected = true;
                  });*/
            },
            child: Container(
              color: sampleList[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              height: 100,
              child: Center(child: Text(sampleList[index].label)),
            ),
          );
        },
      ),
    );
  }

  Widget categView(Size _size) {
    return Container(
      height: _size.height * .8,
      width: _size.width * .8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          // yahan SideNavigator wale onTap ko copy kiya
          // isse symmetry aa jayegi.

          /** tap krte hi baki sbki values ko fir se false ke dega lekin
            // setState mein selected ko true rakhega.
            // isse gesture Detector mein tapping kkr
            // kuch bhi kr skte hin, like humne sirf color change kiya.
            // lekin jaise hi hum bottom navigation change krte hain
            // iski default value mein difference aa jata hai
            // isliye is full method ko
            // initState mein bhi active krdiya with sampleList[0]
             */

          for (var element in sampleList) {
            element.isSelected = false;
          }

          setState(() {
            sampleList[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          WomenCategory(),
          ShoesCategory(),
          BagsCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          HomeGardenCategory(),
          KidsCategory(),
          BeautyCategory(),
        ],
      ),
    );
  }
}

class ItemData {
  String label;
  bool isSelected;
  ItemData({required this.label, this.isSelected = false});
}
// ListView.builder(
//     itemCount: 9,
//     itemBuilder: (context, index) {
//       return Container(
//         decoration: const BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.yellow,
//               width: 2,
//             ),
//           ),
//         ),
//         child: SizedBox(
//           height: 90,
//           child: Center(child: Text('Side ${index + 1}')),
//         ),
//       );
//     }),
//
