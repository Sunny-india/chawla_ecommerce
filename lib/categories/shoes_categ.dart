import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class ShoesCategory extends StatelessWidget {
  const ShoesCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Shoes'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(
              shoes.length,
              (index) {
                return SubCategModel(
                  mainCategName: 'shoes',
                  subCategName: shoes[index],
                  assetName:
                      'https://thumbs.dreamstime.com/b/blue-shoes-29507491.jpg',
                  subCategLabel: shoes[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
