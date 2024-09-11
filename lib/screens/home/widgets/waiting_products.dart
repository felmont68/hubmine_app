import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class WaitingProducts extends StatelessWidget {
  const WaitingProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                height: 120,
                width: MediaQuery.of(context).size.width,
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                height: 120,
                width: MediaQuery.of(context).size.width,
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                height: 120,
                width: MediaQuery.of(context).size.width,
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }
}