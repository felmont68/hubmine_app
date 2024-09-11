import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/hubkens/typography.dart';
import 'package:mining_solutions/utils/custom_launch.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:share_plus/share_plus.dart';

class PostPage extends StatefulWidget {
  final String imageUrl, title, category, datePosted, content, link;
  const PostPage(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.category,
      required this.datePosted,
      required this.content,
      required this.link})
      : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Widget getContent(width) {
    return Html(
        data: widget.content,
        onLinkTap: (String? url, RenderContext context,
            Map<String, String> attributes, element) {
          //open URL in webview, or launch URL in browser, or any other logic here
          launchURL(url!);
        },
        style: {
          "p": Style(
              fontSize: const FontSize(14),
              fontWeight: FontWeight.w400,
              color: gray80,
              letterSpacing: -0.6,
              padding: const EdgeInsets.only(bottom: 4),
              alignment: Alignment.topLeft,
              textAlign: TextAlign.justify),
          "h2": Style(
            fontSize: const FontSize(20),
            fontWeight: FontWeight.w600,
            color: textBlack,
            letterSpacing: -0.6,
            padding: const EdgeInsets.only(top: 4),
            alignment: Alignment.topLeft,
          ),
          "img": Style(
            display: Display.NONE,
            alignment: Alignment.topLeft,
            width: width,
          ),
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(widget.category, style: subHeading1),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Iconsax.arrow_left, color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Share.share(
                      "¡Dale un vistazo a este artículo!\n${widget.title} ${widget.link}",
                      subject: widget.title);
                },
                child: const Icon(Icons.share, color: Colors.black),
              ),
              const SizedBox(
                width: 20,
              ),
            ]),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 18),
              Text(widget.title, style: heading),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Publicado por Hubmine", style: categoryBlog),
                    Row(
                      children: [
                        SvgPicture.asset("assets/truck.svg",
                            color: primaryClr, height: 20),
                        const SizedBox(width: 5),
                        Text(widget.datePosted, style: datePostedBlog),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage, image: widget.imageUrl)),
              const SizedBox(height: 15),
              getContent(size.width),
              const SizedBox(height: 15),
            ]),
          )),
        ));
  }
}
