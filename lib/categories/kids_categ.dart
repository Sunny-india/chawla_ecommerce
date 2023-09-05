import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class KidsCategory extends StatelessWidget {
  const KidsCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Kids'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(kids.length, (index) {
                return SubCategModel(
                  mainCategName: 'kids',
                  subCategName: kids[index],
                  assetName:
                      'https://images.unsplash.com/photo-1627639679638-8485316a4b21?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y3V0ZSUyMGtpZHxlbnwwfHwwfHw%3D&w=1000&q=80',
                  subCategLabel: kids[index],
                );
              })),
        ),
      ],
    );
  }
}
