import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class WaitingCategories extends StatelessWidget {
  const WaitingCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                height: 40, width: 90, borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                height: 40, width: 90, borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                height: 40, width: 79, borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
                height: 40, width: 75, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}