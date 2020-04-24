import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNote = FocusNode();
  final _descriptionFocusNote = FocusNode();

  // To set preview in ImageView when loosing focus we use TextEditingController and _imageFocusNode.
  final _imageUrlControler = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  // we need dispose FocusNode when state cleared
  // otherwise focusNode lead in memory and cause memory leak.
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  @override
  void dispose() {
    super.dispose();
    // we also need to remove listener
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNote.dispose();
    _descriptionFocusNote.dispose();
    _imageUrlControler.dispose();
    _imageFocusNode.dispose();
  }

  // Created to assign edit product value.
  var initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageUrl);
  }

  // didChangeDependencies() always run when page load.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // getting productId as a argument from " UserProductItem " screen. when user click on edit button.
      // we are getting single argument data so we defined " as String "  in ModalRoute.
      var productId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      // - As we use this page to create product at that it the productId = null.
      //   We only get productId when we edit product.
      // - So wee need to check that productId before edit product.
      if (productId != null) {
        var product = Provider.of<ProductProvide>(context, listen: false)
            .findProductById(productId);
        _editedProduct = product;
        // Assign edit product value to initValue.
        initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          // we can not use same for image as we need to set value to imageController.
          //'imageUrl': _editedProduct.imageUrl,
          'price': _editedProduct.price.toString(),
        };
        // Setting imageUrl value to image Controller.
        _imageUrlControler.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrlControler.text.startsWith('http') ||
          !_imageUrlControler.text.startsWith('https')) ||
          (!_imageUrlControler.text.endsWith('.png') &&
              !_imageUrlControler.text.endsWith('.jpg') &&
              !_imageUrlControler.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    // - This will trigger all validator written in TextFormField in Form.
    // - It's return true if all validator return null and
    //   return false if any validator return string and has ana error.
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    // We get _editedProduct.id if we edit product.
    if (_editedProduct.id != null) {
      await Provider.of<ProductProvide>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      // Here we are using .than because noe addProduct() return Future in ProductProvide class.
      try {
        await Provider.of<ProductProvide>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: Text('An Error occurred'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      }
      /*finally {
        // then() return nothing that's why we use _ as a nothing in .then(_)
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }*/
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // assign key with _form which we create.
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                // to set edit product value to TextFormField.
                initialValue: initValues['title'],

                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                // This is show soft keyboard action button with next input
                textInputAction: TextInputAction.next,
                // Use onFieldSubmitted to focus on price filed after click keyboard soft button(next).
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNote);
                },

                // validator take value which is entered into textFormField and return string.
                validator: (value) {
                  if (value.isEmpty) {
                    // here returning message when input data is incorrect.
                    return 'Please enter title';
                  }
                  // here returning null means input data is correct.
                  return null;
                },
                // onSaved() return value currently entered value in TextFormField.
                // and save Title into _editedProduct.
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNote,
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_descriptionFocusNote);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    // here returning message when input data is incorrect.
                    return 'Please enter price';
                  }
                  // tryParse() is use to check invalid number.
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter amount greater than zaro';
                  }
                  // here returning null means input data is correct.
                  return null;
                },
              ),
              TextFormField(
                initialValue: initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNote,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    // here returning message when input data is incorrect.
                    return 'Please enter description';
                  }
                  if (value.length < 10) {
                    return 'Please enter description greater than 10 charecters';
                  }
                  // here returning null means input data is correct.
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlControler.text.isEmpty
                        ? Text('Enter Image url')
                        : FittedBox(
                      child: Image.network(
                        _imageUrlControler.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // We can not use initialValue here because we use controller here.
                      //initialValue: initValues['imageUrl'],

                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlControler,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          // here returning message when input data is incorrect.
                          return 'Please enter image URL';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter valid image URL';
                        }
                        // here returning null means input data is correct.
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
