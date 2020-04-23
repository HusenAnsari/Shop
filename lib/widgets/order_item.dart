import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as order;

class OrderItem extends StatefulWidget {
  // Here we have 2 file with same name "OrderItem" so we use "as" with some name that is "import '../providers/orders.dart' as order;"
  // to differentiate both file.
  final order.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy - hh:mm').format(
                widget.orderItem.dateTime,
              ),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              // Here min value calculate both value that is 1) widget.orderItem.product.length * 20.0 + 100 and
              // 2) 180
              // after calculate set minimum value to height.
              height: min(widget.orderItem.product.length * 20.0 + 10, 100),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.orderItem.product
                    .map(
                      (product) =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${product.quantity}x \$${product.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
