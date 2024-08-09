import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/user.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_storage.dart';
import 'package:instagram_flutter/screens/comments_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool isLiked = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }
  
  void getComments() async{

    try{
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments').get();

      commentLen = snap.docs.length;
    } catch (e){
      showSnackBar(e.toString(), context);
    }
    setState(() {

    });

  }

  // void Liked (){
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        // horizontal: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profileImage'],
                  ),
                ),
                SizedBox(width: 10,),
                Text(widget.snap['username'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) =>
                        Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,

                            ),
                            children: [
                              'Delete',
                            ].map((e) =>
                                InkWell(
                                  onTap: () async{
                                    await FirestoreStorage().deletePosts(widget.snap['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Text(e),
                                  ),

                                ),).toList(),
                          ),
                        ),
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreStorage().likePost(
                  widget.snap['postId'],
                  user.uid,
                  widget.snap['likes']
              );
              setState(() {isLikeAnimating = true;
            }
            );
              },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      child: Icon(Icons.favorite_rounded,
                      color: Colors.white,
                      size: 100,
                      ),
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),

                      onEnd: (){
                        setState(() {
                          isLikeAnimating = false;
                        });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    // onPressed: ()=> Liked(),
                    onPressed: () async {
                      await FirestoreStorage().likePost(
                          widget.snap['postId'],
                          user.uid,
                          widget.snap['likes']
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid) ? const Icon(Icons.favorite,
                    color: Colors.red,
                    ): const Icon(Icons.favorite_border_outlined)
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  CommentsScreen(
                      snap: widget.snap,
                    ),
                    ),
                    );
                  },
                  icon: Icon(Icons.mode_comment_outlined),),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send_outlined),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border_outlined),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.snap['likes'].length} likes'),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: RichText(
                    text:  TextSpan(
                      children: [
                        TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            text: widget.snap['username']
                        ),
                        TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            text: ' ${widget.snap['description']}'
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child:  Text('View all $commentLen comments',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
