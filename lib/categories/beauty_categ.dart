import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class BeautyCategory extends StatelessWidget {
  const BeautyCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Beauty'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(beauty.length, (index) {
                return SubCategModel(
                  mainCategName: 'beauty',
                  subCategName: beauty[index],
                  assetName:
                      'https://burst.shopifycdn.com/photos/confident-young-woman.jpg?width=1200&format=pjpg&exif=1&iptc=1',
                  subCategLabel: beauty[index],
                );
              })),
        ),
      ],
    );
  }
}
