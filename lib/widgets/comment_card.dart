import 'package:flutter/material.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children:  [
          CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
        ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          TextSpan(
                              text: ' ${widget.snap['text']}'
                          ),
                        ]
                      )
                  ),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: DateFormat.yMMMd().format(
                                    widget.snap['datePublished'].toDate()
                                ),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10
                              ),
                            ),
                          ]
                      )
                  ),
                ],
              ),
            ),
          ),
          // const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
