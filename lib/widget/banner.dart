import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:isyarat_kita/sevices/blog_service.dart';
import 'package:isyarat_kita/util/size_extension.dart';

class MyBanner extends StatelessWidget {
  MyBanner({Key? key}) : super(key: key);

  final cs.CarouselSliderController buttonCarouselController = cs.CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeExtension(context).screenHeight * 0.17,
      width: double.infinity,
      child: FutureBuilder<List<BlogModel>>(
        future: BlogService().getLatestBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final List<BlogModel> blogs = snapshot.data ?? [];
          final List<BlogModel> articles = blogs.where((blog) {
            return blog.type == Type.ARTICLE;
          }).toList();

          if (articles.isEmpty) {
            return const Center(
              child: Text("Belum ada artikel tersedia."),
            );
          }

          return Stack(
            children: [
              CarouselSlider.builder(
                itemCount: articles.length,
                itemBuilder: (context, index, realIndex) {
                  final blog = articles[index];
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            blog.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        top: SizeExtension(context).screenHeight * 0.06,
                        left: SizeExtension(context).screenWidth * 0.04,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: SizedBox(
                                width:SizeExtension(context).screenWidth * 0.22 ,
                                child: Text(
                                  blog.title,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width:SizeExtension(context).screenWidth * 0.5 ,
                              child: Text(
                                blog.content,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: blogs.length > 1,
                  enlargeCenterPage: true,
                  viewportFraction: 0.95,
                  aspectRatio: 2.0,
                  initialPage: 0,
                  height: 150,
                  enableInfiniteScroll: blogs.length > 1,
                  scrollPhysics: blogs.length > 1 ? null : const NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          );
        }
      )
    );
  }
}