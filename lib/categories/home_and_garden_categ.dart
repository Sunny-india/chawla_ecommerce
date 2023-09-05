import 'package:flutter/material.dart';
import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class HomeGardenCategory extends StatelessWidget {
  const HomeGardenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Home Garden'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: List.generate(homeGarden.length, (index) {
                return SubCategModel(
                  mainCategName: 'home & garden',
                  subCategName: homeGarden[index],
                  assetName:
                      'https://thumbs.dreamstime.com/b/beautiful-manicured-lawn-summer-garden-border-bright-colourful-flowering-shrubs-trees-32424569.jpg',
                  subCategLabel: homeGarden[index],
                );
              })),
        ),
      ],
    );
  }
}
