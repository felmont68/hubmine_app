import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HomeContentSkeleton extends StatelessWidget {
  const HomeContentSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonItem(
                    child: SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 30.0,
                          width: 140.0,
                          borderRadius: BorderRadius.circular(9)),
                    ),
                  ),
                  SkeletonItem(
                    child: SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 32.0, left: 32.0, top: 14),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 20,
                            width: 100,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 27,
                            width: 200,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 27,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            padding: const EdgeInsets.only(
                                top: 23, left: 20, right: 20),
                            height: MediaQuery.of(context).size.width / 3 + 30,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            padding: const EdgeInsets.only(top: 35),
                            height: 27,
                            width: 120,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            padding: const EdgeInsets.only(top: 20),
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            padding: const EdgeInsets.only(top: 15),
                            height: 27,
                            width: 160,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SkeletonItem(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                            padding: const EdgeInsets.only(top: 20, bottom: 70),
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
