import 'package:afg_sewing/custom_widgets/custom_container.dart';
import 'package:flutter/material.dart';

class OrderFullScreen extends StatefulWidget {
  final int pageIndex;

  const OrderFullScreen({super.key, required this.pageIndex});

  @override
  State<OrderFullScreen> createState() => _OrderFullScreenState();
}

class _OrderFullScreenState extends State<OrderFullScreen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) => CustomContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/yekhan/yekhan${widget.pageIndex > 11 ? 10 : index}.jpg'),
              fit: BoxFit.cover
            ),
          ),
        ),
      ),
    );
  }
}
