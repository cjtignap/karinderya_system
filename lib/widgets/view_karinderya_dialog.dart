import 'package:flutter/material.dart';
import 'package:karinderya_system/screens/messages_screen.dart';
import '../constants.dart';

class ViewKarinderyaDialog extends StatelessWidget {
  final String karinderyaName;
  ViewKarinderyaDialog({required this.karinderyaName});

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
              karinderyaName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Image(
                image: AssetImage('images/welcome_banner.png'), height: 200),
            Row(
              children: [
                Expanded(
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kPrimaryColor,
                    elevation: 5,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Review',
                        style: TextStyle(color: Colors.white),
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
                                MessagesScreen(name: karinderyaName)),
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
