import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class AccessoriesCategory extends StatelessWidget {
  const AccessoriesCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Accessories'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(accessories.length, (index) {
                return SubCategModel(
                  mainCategName: 'accessories',
                  subCategName: accessories[index],
                  assetName:
                      'https://i.pinimg.com/originals/81/08/96/810896b77bd0c1371210639c80eb81a2.jpg',
                  subCategLabel: accessories[index],
                );
              })),
        ),
      ],
    );
  }
}
