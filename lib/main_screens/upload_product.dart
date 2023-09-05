/// This page is meant for uploading products by Suppliers only.
///Not Accessible for Customers.

import 'package:chawla_trial_udemy/constants.dart';
import 'package:chawla_trial_udemy/my_widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({Key? key}) : super(key: key);

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  // copied all lists from the categ_list for the purpose of easiness here.
  List<String> maincateg = [
    'category',
    'men',
    'women',
    'accessories',
    'shoes',
    'electronics',
    'home & garden',
    'beauty',
    'kids',
    'bags'
  ];

  List<String> men = [
    'subcategory',
    'shirt',
    't-shirt',
    'jacket',
    'vest',
    'coat',
    'jeans',
    'shorts',
    'suit',
    'others'
  ];

  List<String> women = [
    'subcategory',
    'dress',
    '2pcs sets',
    't-shirt',
    'top',
    'skirt',
    'jeans',
    'pants',
    'coat',
    'jacket',
    'other'
  ];

  List<String> electronics = [
    'subcategory',
    'phone',
    'computer',
    'laptop',
    'smart tv',
    'phone holder',
    'charger',
    'usb cables',
    'head phones',
    'smart watch',
    'tablet',
    'mouse',
    'keyboard',
    'gaming',
    'ohter'
  ];

  List<String> accessories = [
    'subcategory',
    'slippers',
    'classic',
    'casual',
    'boots',
    'canvas',
  ];

  List<String> homeGarden = [
    'subcategory',
    'Garden 1',
    'Garden 2',
    'Garden 3',
    'Garden 4',
    'Garden 5',
  ];

  List<String> shoes = [
    'subcategory',
    'slippers',
    'classic',
    'casual',
    'boots',
    'canvas',
  ];

  List<String> bags = [
    'subcategory',
    'Dockers',
    'Holdaals',
    'Office',
    'Casuals',
    'Party',
  ];

  List<String> kids = [
    'subcategory',
    'Aaryan',
    'Kabeer',
    'Angad',
    'MJ',
    'Sunny',
  ];

  List<String> beauty = [
    'subcategory',
    'Beauty1',
    'Beauty2',
    'Beauty3',
    'Beauty4',
    'Beauty5',
    'Beauty6',
  ];

  List<String> storingList = [];

  //---created this key to use all the validators
  // from different TFF under it.---//
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //---created to use MyMesssageHandler class here.---//
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  //--variables to store data from all the TFF down--//

  late String productName;
  late double productPrice;
  late double productQty;
  late String productDescription;
  /* made nullable because supplier can or can't offer a discount.
  So default is null too*/
  int? discount = 0;

  //
  final ImagePicker _imagePicker = ImagePicker();

  /*--If we do not make it nullable, its condition would always be true,and won't work in
   first container in the column down. So made it nullable.--*/
  List<XFile>? imagesList = [];

  //--for picking any error while fetching images--//
  dynamic pickedImageError;

  /// MOST IMPORTANT
  /*  Whatever the value we pass to our DropdownButton's value; That must be consisted
   in that given list, which we pass to DropdownMenuItem's items property.
   Hence initialized it the same way for both button values. Detail is on onChanged
   method for the first DropdownButton down there. and have them validated in our
   uploadProduct() method too.
  Thanks.*/

  String mainCategoryDropValue = 'category';
  String subCategoryDropValue = 'subcategory';
  List<String> imageURLList = [];

  bool isProcessing = false;

  late String proId;

  /* Most of this block is already used in SupplierSignUp page, here are some
   important changes
   In stead of picking single image, we're picking multiple images, hence no need to
   provide which source (either camera or Gallery) it requires, (it takes gallery
   by default.) and to put all those picked images path,
   we created the List of XFile type above, in stead of one XFile variable.*/
  void pickProductImages() async {
    try {
      final pickedImages = await _imagePicker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesList!.addAll(pickedImages);
      });
    } catch (e) {
      pickedImageError = e;
      print(pickedImageError);
    }
  }

  /*Now that, we've picked our images, we need to provide their path to our XFile type list.
   so put all those path in File and used Image.file method on them.
   Down the line, we used this Widget to be seen in our first container, but conditionally.
  Thanks.*/

  Widget previewImages() {
    if (imagesList!.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imagesList!.length,
          itemBuilder: (context, index) {
            return Image.file(
              File(imagesList![index].path),
              fit: BoxFit.cover,
            );
          });
    } else {
      return const Center(
        child: Text(
          'You\'ve not picked any image yet.',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  //
  void selectCategory(String? value) {
    if (value == 'category') {
      storingList = [];
    } else if (value == 'men') {
      storingList = men;
    } else if (value == 'women') {
      storingList = women;
    } else if (value == 'accessories') {
      storingList = accessories;
    } else if (value == 'shoes') {
      storingList = shoes;
    } else if (value == 'electronics') {
      storingList = electronics;
    } else if (value == 'home & garden') {
      storingList = homeGarden;
    } else if (value == 'beauty') {
      storingList = beauty;
    } else if (value == 'kids') {
      storingList = kids;
    } else if (value == 'bags') {
      storingList = bags;
    }
  }

  //
  Future<void> uploadImagesFirst() async {
    /* The first 'if' would combine both the checks in this function,
     the image check, and other validations too.*/

    if (imagesList!.isNotEmpty) {
      if (mainCategoryDropValue != 'category' &&
          subCategoryDropValue != 'subcategory') {
        if (_formKey.currentState!.validate()) {
          /**MOST IMPORTANT*/
          /* When we use onSaved method in our TFF, we need to use _formKey.currentState!.save() method
           in order to make that onSaved method complete its job.
           If we do not call this .save() method, it would give us an error of type that
           our variable/s have not been initialised, even though they've already been.
           WHY?
           Now if the user accidentally leaves any field empty,
          it would not cause any error. */
          _formKey.currentState!.save();
          if (imagesList!.isNotEmpty) {
            setState(() {
              isProcessing = true;
            });
            try {
              for (var image in imagesList!) {
                firebase_storage.Reference imageRef = firebase_storage
                    .FirebaseStorage.instance
                    .ref('products/${path.basename(image.path)}');
                await imageRef.putFile(File(image.path)).whenComplete(() async {
                  await imageRef.getDownloadURL().then((value) {
                    imageURLList.add(value);
                  });
                });
              } // storing images through for loop ends here.
            } catch (e) {
              print(e);
            }
          } else {
            // inner most else condition to be applied.
          }
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Please Enter all the fields..!');
        }
      } else {
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'Please Pick Category and SubCategory First');
      }

      //todo: For uploading those images in that ListView//
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please Pick an Image first');
    }
  }

  //
  void uploadDataLater() async {
    if (imageURLList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');
      proId = Uuid().v4();
      await productRef.doc(proId).set({
        'productid': proId,
        'maincateg': mainCategoryDropValue,
        'subcateg': subCategoryDropValue,
        'price': productPrice,
        'instock': productQty,
        'productname': productName,
        'productdescription': productDescription,
        'productimages': imageURLList,
        'discount': discount,
        'sid': FirebaseAuth.instance.currentUser!.uid,
      }).whenComplete(() {
        setState(() {
          // used after we successfully uploaded our product to Database.
          imagesList = [];
          mainCategoryDropValue = 'category';
          storingList = [];
          imageURLList = [];
          // subCategoryDropValue = 'subcategory';
          isProcessing =
              false; // so that user may not double click on upload button, and may see its progress.
        });
        _formKey.currentState!.reset();
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Thank-you');
    } else {
      print('No images could be sent to the server');
    }
  }

  // The whole function is broken into two parts.
  // The first one is used to upload, and fetch images through a loop.
  // The second one is used, only after that loop in done, and it validates the first one.
  void uploadProduct() async {
    await uploadImagesFirst().whenComplete(
      () => uploadDataLater(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // can create a context type variable only when it is initialed in build method.
    Size size = MediaQuery.sizeOf(context);
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            //1. When true, we see the bottom part of the page,
            // instead of the first upper part.
            // reverse: true,
            //2.
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 6),

                    ///Row containing image container and DropdownButtons
                    Row(
                      children: [
                        /// For showing images in a ListView.
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(11),
                                bottomLeft: Radius.circular(11)),
                            color: Colors.blueGrey.shade100,
                          ),
                          height: size.height * .47,
                          width: size.width * .47,
                          child: previewImages(),
                        ),

                        /// For storing both DropdownButtons in it.
                        SizedBox(
                          height: size.height * .50,
                          width: size.width * .50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// Ist Column containing the first main category DropdownButton in it.
                              Column(
                                children: [
                                  const Text(
                                    'Select Main Category*',
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  //--The main DropdownButton in it. Used Container for its decoration.--//
                                  Container(
                                    //  alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: MyConstants.buttonTextColor),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        iconEnabledColor: Colors.red,

                                        menuMaxHeight: 400,
                                        alignment: Alignment.center,
                                        borderRadius: BorderRadius.circular(20),
                                        isDense: true,
                                        iconSize: 36,
                                        dropdownColor:
                                            Colors.deepPurple.shade100,
                                        isExpanded: false,
                                        icon: const Icon(
                                          Icons.arrow_drop_down_outlined,
                                        ),
                                        value: mainCategoryDropValue,
                                        items: maincateg
                                            .map<DropdownMenuItem<String>>((i) {
                                          return DropdownMenuItem<String>(
                                            value: i,
                                            child: Text(i),
                                          );
                                        }).toList(),

                                        /// Because we are creating two DropdownButtons; the latter depending upon
                                        /// the first one;. We first sat the main button's default value as a variable
                                        /// mentioned in the main list. In our case, we sat that variable as a hint to the user as
                                        /// 'category' in our mainCategList. and based on that sat a universal value for
                                        /// its dependant button as 'subcategory' in each dependant list.
                                        /// This all happened in setState for the first button.
                                        /// 2. We created an empty list and based on the selection of our first button's
                                        /// value, and passed it to the items property for the dependant button.
                                        /// Further, we kept changing and storing our all other lists to this empty list.
                                        /// This all happened in multiple if conditions for the first button's onChanged method.
                                        /// Thanks.

                                        onChanged: (String? value) {
                                          selectCategory(value);
                                          setState(() {
                                            mainCategoryDropValue = value!;
                                            subCategoryDropValue =
                                                'subcategory';
                                          });

                                          print(mainCategoryDropValue);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// 2nd Column containing the second subcategory DropdownButton in it.
                              Column(
                                children: [
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Select Sub Category*',
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  //--The dependant DropdownButton in it. Used Container for its decoration.--//
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: MyConstants.buttonTextColor,
                                            width: 1)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        iconEnabledColor: Colors.red,
                                        menuMaxHeight: 400,
                                        alignment: Alignment.center,
                                        disabledHint:
                                            const Text('Select Category'),
                                        dropdownColor:
                                            Colors.deepPurple.shade100,
                                        borderRadius: BorderRadius.circular(25),
                                        iconSize: 34,
                                        icon: const Icon(
                                          Icons.arrow_drop_down_outlined,
                                        ),
                                        value: subCategoryDropValue,
                                        items: storingList
                                            .map<DropdownMenuItem<String>>((i) {
                                          return DropdownMenuItem(
                                            value: i,
                                            child: Text(i),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            subCategoryDropValue = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                              thickness: 1, color: MyConstants.buttonTextColor),

                          /// 1st TextFormField asking for Product names.
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .93,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Product Name..!';
                                } else {
                                  return null;
                                }
                              },

                              /*--This onChanged method creates a problem of crashing the
                               code, if user accidentally leaves the TFF empty.
                               So, I used onSaved method in stead on all the TFF down
                               Coz by default that gives the ability to null check on value--//

                              // onChanged: (value) => productName = value,

                              */
                              onSaved: (value) {
                                productName = value!;
                              },
                              decoration: inputTextFormFieldDecoration.copyWith(
                                  labelText: 'Name'),
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// 2nd TextFormField asking for quantity
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .55,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Quantity??';
                                } else if (value.isValidQuantity() != true) {
                                  return 'Enter valid quantity';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) =>
                                  productQty = double.parse(value!),
                              keyboardType: TextInputType.number,
                              decoration: inputTextFormFieldDecoration.copyWith(
                                  labelText: 'Quantity'),
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// 3rd TextFormField asking for Product Prices.
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '@ What Price??';
                                    } else if (value.isValidPrice() != true) {
                                      return 'Enter Valid Price only';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) =>
                                      productPrice = double.parse(value!),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: inputTextFormFieldDecoration
                                      .copyWith(labelText: 'Price..!'),
                                ),
                              ),
                              const SizedBox(width: 16),

                              /// last minute edit TFF for discount
                              Expanded(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  child: TextFormField(
                                    /* no more than two digits for discount*/
                                    maxLength: 2,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return null; // discount is optional, that's why.
                                      } else if (value.isNumeric() != true) {
                                        return 'Enter Valid Discount only';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) =>
                                        discount = int.parse(value!),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: inputTextFormFieldDecoration
                                        .copyWith(labelText: 'discount..!'),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          /// 4th TextFormField asking for Product Descriptions.
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .93,
                            child: TextFormField(
                              validator: (value) {
                                // if value!=null check todo
                                if (value!.isEmpty) {
                                  return 'Please describe about the product..';
                                } else {
                                  return null;
                                }
                              },
                              //
                              onSaved: (value) {
                                productDescription = value!;
                              },
                              // Its maxLength determines its size automatically.
                              maxLength: 800,
                              maxLines: 5,
                              decoration: inputTextFormFieldDecoration.copyWith(
                                  hintText: 'Description'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        ///---Multiple buttons in this Column For picking and uploading images--//
        floatingActionButton: isProcessing == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// Upper Button for picking multiple images from the gallery
                  FloatingActionButton(
                    backgroundColor: MyConstants.buttonTextColor,
                    onPressed: () {
                      // The same button would work both ways, first it would empty the whole list,
                      // and then it would pick other images through the method created above.
                      // for users' ui experience.
                      setState(() {
                        imagesList = [];
                      });
                      // todo: to pick images from Gallery.
                      pickProductImages();
                    },
                    child: imagesList!.isEmpty
                        ? const Icon(Icons.photo_library)
                        : const Icon(Icons.reset_tv_outlined),
                  ),
                  const SizedBox(width: 5),

                  // Lower Button for uploading those images in that ListView in first Container
                  // of this page.
                  FloatingActionButton(
                    backgroundColor: MyConstants.buttonTextColor,
                    onPressed: () {
                      uploadProduct();
                    },
                    child: const Icon(Icons.upload),
                  )
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  // This InputDecoration was to be used at many places on this page, so created a
  // model variable for it. And used it at many places. Further its .copyWith() method
  // gives us the ability to manipulate its other properties too.
  var inputTextFormFieldDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.purple.shade700),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.purple.shade700, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: MyConstants.buttonTextColor, width: 1),
    ),
  );
}

//--extension are declared outside all the classes---//
extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^((([1-9][0-9]*[.]*)||([0]*[.]))([0-9]{1,3}))$')
        .hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

/// [0-9]* because made this discount type variable optional.
extension NumericValidator on String {
  bool isNumeric() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
//--I used this method, but why is this not taking value in a single digit?--//
//RegExp(r'^([1-9][0-9]*)([\.]*[0-9]{1,2})$')
