import 'package:flutter/material.dart';

import '../minor_screens/subcateg_products.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({super.key, required this.headerLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
            letterSpacing: 1.5, fontSize: 30, fontFamily: 'FontTwo'),
      ),
    );
  }
}

class SubCategModel extends StatelessWidget {
  final String mainCategName;
  final String subCategName;
  final String assetName;
  final String subCategLabel;

  const SubCategModel(
      {super.key,
      required this.mainCategName,
      required this.subCategName,
      required this.assetName,
      required this.subCategLabel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SubCategProducts(
                mainCategName: mainCategName,
                subCategName: subCategName,
                //Categories().men[index], ye add krna hai;
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            color: Colors.blue,

            // later to be sourced from the assests
            // wahan images ko naming ke end mein indexing deni hai
            // for easy fetching
            child: CachedNetworkImage(
              imageUrl: assetName,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Text(
              subCategLabel,
            ),
          ),
          //Categories().men[index]// ye add krna hai
        ],
      ),
    );
  }
}
