import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategHeaderLabel(headerLabel: 'Men'),
          SizedBox(
            height: MediaQuery.of(context).size.height * .65,
            child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(
                men.length,
                (index) {
                  return SubCategModel(
                    mainCategName: 'men',
                    subCategName: men[index],
                    assetName:
                        'https://contents.mediadecathlon.com/p1484240/ab565f3675dbdd7e3c486175e2c16583/p1484240.jpg?format=auto&quality=70&f=1024x0',
                    subCategLabel: men[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
