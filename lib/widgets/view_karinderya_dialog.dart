import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/screens/messages_screen.dart';
import '../constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewKarinderyaDialog extends StatefulWidget {
  final String karinderyaName;
  final UserDetails userDetails;
  ViewKarinderyaDialog(
      {required this.karinderyaName, required this.userDetails});

  @override
  State<ViewKarinderyaDialog> createState() => _ViewKarinderyaDialogState();
}

class _ViewKarinderyaDialogState extends State<ViewKarinderyaDialog> {
  double myRating = 3;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.karinderyaName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Image(
              image: AssetImage('images/welcome_banner.png'),
              height: 200,
            ),
            const Text(
              'Store Rating',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('reviews')
                    .where('karinderya', isEqualTo: widget.karinderyaName)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    double totalRating = 0;
                    var reviews = snapshots.data!.docs;

                    for (var review in reviews) {
                      totalRating = totalRating +
                          double.parse(review.get('rating').toString());
                    }
                    totalRating = totalRating / reviews.length;
                    print(totalRating);
                    return RatingBar.builder(
                      ignoreGestures: true,
                      initialRating: totalRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    );
                  } else {
                    return RatingBar.builder(
                      ignoreGestures: true,
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your rating of store',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  myRating = rating;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kAccentColor,
                    elevation: 5,
                    child: TextButton(
                      onPressed: () async {
                        var snapshot = await _firestore
                            .collection('reviews')
                            .where('customer',
                                isEqualTo: widget.userDetails.name)
                            .get();
                        if (snapshot.docs.length > 0) {
                          await _firestore
                              .collection('reviews')
                              .doc(snapshot.docs.first.id)
                              .update({'rating': myRating});
                        } else {
                          await _firestore.collection('reviews').add({
                            'karinderya': widget.karinderyaName,
                            'rating': myRating,
                            'customer': widget.userDetails.name
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: (Text('Rating succesfully saved')),
                            action: SnackBarAction(
                                label: 'Hide',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }),
                          ),
                        );
                      },
                      child: const Text(
                        'Save Rating',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kPrimaryColor,
                    elevation: 5,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) =>
                                MessagesScreen(name: widget.karinderyaName)),
                          ),
                        );
                      },
                      child: const Text(
                        'Message',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
