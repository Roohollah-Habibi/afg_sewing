import 'package:afg_sewing/custom_widgets/sample_images.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> with TickerProviderStateMixin {
  late TabController tabController;
  final List<SampleImages> imgSrs = List.generate(
      11,
      (index) =>
          SampleImages(imgSrc: 'assets/images/yekhan/yekhan${index + 1}.jpg'));
  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: imgSrs.length, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.black,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {Navigator.of(context).pushReplacementNamed(RouteManager.root);},
        child: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Stack(alignment: Alignment.center, children: [
          TabBarView(
            controller: tabController,
            children: imgSrs,
          ),
          Positioned(
            bottom: 50,
            child: TabPageSelector(
              controller: tabController,
              color: Colors.blueGrey,
              selectedColor: Colors.black,
              indicatorSize: 13,
            ),
          ),
        ]),
      ),
    );
  }
}
