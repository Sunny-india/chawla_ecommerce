import 'package:flutter/material.dart';

import 'package:chawla_trial_udemy/utilities/categ_list.dart';

import '../my_widgets/categ_widgets.dart';

class BagsCategory extends StatelessWidget {
  const BagsCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategHeaderLabel(headerLabel: 'Bags'),
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: GridView.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(
              bags.length,
              (index) {
                return SubCategModel(
                  mainCategName: 'bags',
                  subCategName: bags[index],
                  assetName:
                      'https://media.istockphoto.com/id/1154597724/photo/yellow-handbag.jpg?s=612x612&w=0&k=20&c=dsQ9iAiBEmlSUZUOdTuwgNc2O6BiV1iK9FbsxmVtj9I=',
                  subCategLabel: bags[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
