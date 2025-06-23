import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void showWelcomeBanner(BuildContext context, {required String firstname}) {
  print('showWelcomeBanner called with firstname: $firstname');
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) {
      print('showWelcomeBanner pageBuilder executed');
      return Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Không được giấu em chuyện gì nha admin $firstname, nếu như anh buồn em sẽ luôn bênh anh ❤️',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                CachedNetworkImage(
                  imageUrl: 'https://i.postimg.cc/8CX6WHLb/44ddd271bd6dc4ca55a309542e21a1ab-removebg-preview.png',
                  height: 150,
                  placeholder: (context, url) => CircularProgressIndicator(), 
                  errorWidget: (context, url, error) => Text('Không tải được ảnh'),
                ),

                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    print('Close button pressed');
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Đóng',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      print('showWelcomeBanner transitionBuilder executed');
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset(0, 0),
        ).animate(animation),
        child: child,
      );
    },
  ).then((_) {
    print('showWelcomeBanner dialog closed');
  });
}