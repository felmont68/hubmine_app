import 'package:flutter/material.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/services/blog_services.dart';
import 'package:mining_solutions/widgets/post_preview.dart';
import 'package:shimmer/shimmer.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Blog Hubmine", style: subHeading1),
      ),
      body: FutureBuilder(
          future: fetchWpPosts(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Map wpPost = snapshot.data![index];
                  return PostPreview(
                    idPost: wpPost["id"].toString(),
                    href: wpPost["_links"]["wp:featuredmedia"][0]["href"],
                    linkToArticle: wpPost["link"],
                    datePosted: wpPost["date"],
                    title: wpPost["title"]["rendered"],
                    description: wpPost["excerpt"]["rendered"],
                    content: wpPost["content"]["rendered"],
                  );
                },
              );
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: primaryClr),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: primaryClr,
                      child: Text("Cargando posts...", style: subHeading2))
                ],
              ));
            }
          }),
    );
  }
}
