import 'package:afg_sewing/custom_widgets/custom_container.dart';
import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SamplesFullScreen extends StatefulWidget {
  final int pageIndex;
  final List<String> imgSrc;

  const SamplesFullScreen({super.key, required this.pageIndex,required this.imgSrc});

  @override
  State<SamplesFullScreen> createState() => _SamplesFullScreenState();
}

class _SamplesFullScreenState extends State<SamplesFullScreen> {
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
        itemCount: context.read<SampleProvider>().imgList.length,
        controller: pageController,
        itemBuilder: (context, index) {
          String updatedImgPath = widget.imgSrc[index].replaceAllMapped(RegExp(r'\d+(?=\.\w+$)'), (match) => '$index');
          return CustomContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  updatedImgPath),
              fit: BoxFit.cover
            ),
          ),
        );
        },
      ),
    );
  }
}
