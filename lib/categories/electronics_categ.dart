import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class ElectronicsCategory extends StatelessWidget {
  const ElectronicsCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Electronics'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(electronics.length, (index) {
                return SubCategModel(
                  mainCategName: 'electronics',
                  subCategName: electronics[index],
                  assetName:
                      'https://gomechanic.in/blog/wp-content/uploads/2020/01/Blog-Post-2019electricscootersowdown-01-e1602833914786.jpg',
                  subCategLabel: electronics[index],
                );
              })),
        ),
      ],
    );
  }
}
