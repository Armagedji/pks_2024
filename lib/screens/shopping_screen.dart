import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';

class ShoppingScreen extends StatefulWidget {
  final List<ShopProduct> shoppingProducts;

  const ShoppingScreen({super.key, required this.shoppingProducts});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  void _updateQuantity(int index, int change) {
    setState(() {
      widget.shoppingProducts[index].quantity += change;
      if (widget.shoppingProducts[index].quantity < 1) {
        widget.shoppingProducts.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.shoppingProducts.removeAt(index);
    });
  }

  String _correctWord(int quantity) {
    if (quantity == 1) {
      return ('1 пациент');
    } else if (quantity < 5 && quantity > 1) {
      return ('$quantity пациента');
    } else {
      return ('$quantity пациентов');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Корзина',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          titleSpacing: 27,
        ),
        body: widget.shoppingProducts.isEmpty
            ? const Center(child: Text('Ваша корзина пуста'))
            : Container(
                margin: const EdgeInsets.only(top: 38),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.shoppingProducts.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 138,
                              margin:
                                  const EdgeInsets.fromLTRB(27.5, 0, 27.5, 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 100),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.shoppingProducts[index].product
                                              .title,
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => _removeItem(index),
                                          icon: const Icon(Icons.clear_rounded,
                                              size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${widget.shoppingProducts[index].product.price} ₽',
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _correctWord(widget
                                                .shoppingProducts[index]
                                                .quantity),
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Container(
                                            height: 32,
                                            width: 64,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  245, 245, 249, 100),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            margin:
                                                const EdgeInsets.only(left: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: IconButton(
                                                    iconSize: 20,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    onPressed: () =>
                                                        _updateQuantity(
                                                            index, -1),
                                                    icon: const Icon(
                                                      Icons.remove,
                                                      color: Color.fromRGBO(
                                                          184, 193, 204, 100),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 16,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              235,
                                                              235,
                                                              235,
                                                              100),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: IconButton(
                                                    iconSize: 20,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    onPressed: () =>
                                                        _updateQuantity(
                                                            index, 1),
                                                    icon: const Icon(
                                                      Icons.add,
                                                      color: Color.fromRGBO(
                                                          147, 147, 150, 100),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(29, 24, 29, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Сумма',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${widget.shoppingProducts.fold(0, (sum, price) => sum + price.quantity * int.parse(price.product.price))} ₽',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 30),
                        height: 56,
                        width: 335,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: InkWell(
                          onTap: () {},
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Перейти к оформлению заказа',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
