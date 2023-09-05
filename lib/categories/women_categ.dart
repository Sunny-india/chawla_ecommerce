import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class WomenCategory extends StatelessWidget {
  const WomenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Women'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(women.length, (index) {
                return SubCategModel(
                  mainCategName: 'women',
                  subCategName: women[index],
                  assetName:
                      'https://rukminim1.flixcart.com/image/832/832/xif0q/kurta/1/h/g/m-pw333-purshottam-wala-original-imag8zf6ybkmhehy-bb.jpeg?q=70',
                  subCategLabel: women[index],
                );
              })),
        ),
      ],
    );
  }
}
