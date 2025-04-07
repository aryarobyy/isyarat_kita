import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:isyarat_kita/sevices/blog_service.dart';

class MyBanner extends StatelessWidget {
  MyBanner({Key? key}) : super(key: key);

  final cs.CarouselSliderController buttonCarouselController = cs.CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
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
          final List<BlogModel> blogs = snapshot.data!;
          return Stack(
            children: [
              CarouselSlider.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index, realIndex) {
                  final blog = blogs[index];
                  print(blog.type);
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
                        bottom: 40,
                        left: 20,
                        child: SizedBox(
                          width: 220,
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
                        )
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: SizedBox(
                          width: 220,
                          child: Text(
                            blog.content,
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        )
                      )
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