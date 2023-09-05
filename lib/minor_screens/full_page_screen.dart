import 'package:cached_network_image/cached_network_image.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class FullPageScreen extends StatefulWidget {
  /// Just because we need  a type of list  here from our previous page.
  /// So on our previous page, instead of passing the whole value of a snapshot
  /// we would fetch the the dynamic type of list from there to here.
  final List<dynamic> imagesFromProductDetailPage;
  const FullPageScreen({super.key, required this.imagesFromProductDetailPage});

  @override
  State<FullPageScreen> createState() => _FullPageScreenState();
}

class _FullPageScreenState extends State<FullPageScreen> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        leading: AppBarBackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// To show the first main image fetched from firebase, from the ProductDetailScreen here. ///
              SizedBox(
                height: size.height * .50,
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  controller: _controller,
                  children: buildImagesList(),
                ),
              ),

              /// to show other images from the list in firebase
              /// as a horizontal list in this container///
              SizedBox(
                height: size.height * .37,
                child: buildImageView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildImagesList() {
    return List.generate(
      widget.imagesFromProductDetailPage.length,
      (index) {
        return InteractiveViewer(
          transformationController: TransformationController(),

          /// for the sake of enabling zooming in or out facility, this image is
          /// wrapped in InteractiveViewer Widget.
          child: CachedNetworkImage(
            imageUrl: widget.imagesFromProductDetailPage[index].toString(),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  ListView buildImageView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imagesFromProductDetailPage.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          /// used this functionality to make the relevant image be seen
          /// on the upper part of the page. So controlled the page controller here.
          onTap: () {
            setState(() {
              _controller.jumpToPage(index);
            });
          },
          child: Container(
            width: 135,
            margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.imagesFromProductDetailPage[index].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
