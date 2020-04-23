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
  var _editedProduct =
  Product(id: null,
      title: '',
      description: '',
      imageUrl: '',
      price: 0);

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

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageUrl);
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

  void _saveForm() {
    // - This will trigger all validator written in TextFormField in Form.
    // - It's return true if all validator return null and
    //   return false if any validator return string and has ana error.
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<ProductProvide>(context, listen: false)
        .addProduct(_editedProduct);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // assign key with _form which we create.
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
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
                    id: null,
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNote,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNote);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
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
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNote,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
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
                          id: null,
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