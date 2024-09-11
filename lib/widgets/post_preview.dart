import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/screens/blog/post_page.dart';
import 'package:mining_solutions/services/blog_services.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:shimmer/shimmer.dart';

import 'button_model.dart';

class PostPreview extends StatefulWidget {
  final String href,
      title,
      description,
      content,
      idPost,
      datePosted,
      linkToArticle;
  const PostPreview({
    Key? key,
    required this.idPost,
    required this.href,
    required this.datePosted,
    required this.title,
    required this.description,
    required this.content,
    required this.linkToArticle,
  }) : super(key: key);

  @override
  State<PostPreview> createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  var imageUrl = "";
  var _categoryBlog = "";
  var _datePosted = "";
  Widget shortDescription() {
    return Html(data: widget.description, style: {
      "p": Style(
        fontSize: const FontSize(14),
        fontWeight: FontWeight.w400,
        color: gray80,
        letterSpacing: -0.6,
        padding: const EdgeInsets.all(0),
        alignment: Alignment.topLeft,
      ),
    });
  }

  String formatDate(date) {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(tempDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostPage(
                    imageUrl: imageUrl,
                    title: widget.title,
                    category: _categoryBlog,
                    datePosted: _datePosted,
                    content: widget.content,
                    link: widget.linkToArticle)));
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 22.0, left: 22.0, top: 10, bottom: 10),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: fetchWPPostImage(widget.href),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      imageUrl = snapshot.data["guid"]["rendered"];
                      return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: snapshot.data["guid"]["rendered"]));
                    } else {
                      return SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: Shimmer.fromColors(
                            baseColor: accentRed,
                            highlightColor: Colors.yellow,
                            child: SizedBox(
                                width: size.width, height: size.height / 2)),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: FutureBuilder(
                    future: fetchCategory(widget.idPost),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        _categoryBlog = snapshot.data[0]["name"];
                        _datePosted = formatDate(widget.datePosted).toString();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Text(snapshot.data[0]["name"],
                                  style: bodyLink),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/calendar.svg",
                                    color: gray40, width: 20),
                                const SizedBox(width: 5),
                                Text(formatDate(widget.datePosted).toString(),
                                    style: bodyGray80),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(
                                color: primaryLightClr,
                                border: Border.all(
                                  color: primaryLightClr,
                                ),
                                borderRadius: BorderRadius.circular(
                                    10) // use instead of BorderRadius.all(Radius.circular(20))
                                ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Categoría", style: categoryBlog),
                            ));
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(widget.title, style: heading3),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: shortDescription(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Button(
                    color: primaryClr,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: SvgPicture.asset("assets/small-arrow-right.svg",
                          color: Colors.white),
                    ),
                    text: Text(
                      "Leer más",
                      style: subHeading2White,
                    ),
                    width: size.width / 1,
                    height: size.height * 0.055,
                    action: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostPage(
                                  imageUrl: imageUrl,
                                  title: widget.title,
                                  category: _categoryBlog,
                                  datePosted: _datePosted,
                                  content: widget.content,
                                  link: widget.linkToArticle)));
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }
}
