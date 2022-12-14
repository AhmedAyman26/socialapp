import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/message_model.dart';
import 'package:socialapp/models/social_user_model.dart';
import 'package:socialapp/screens/social_layout/cubit/cubit.dart';
import 'package:socialapp/screens/social_layout/cubit/states.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;
  ChatDetailsScreen({required this.userModel});

  var messageController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context)
      {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      '${userModel.username}',
                    )
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.length>0,
                builder: (context)=>Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context,index)
                          {
                            var messages =SocialCubit.get(context).messages[index];
                            if(SocialCubit.get(context).userModel!.uId==messages.senderId)
                              return buildMyMessage(messages);

                            return buildMessage(messages);
                          },
                          separatorBuilder: (context,index)=>SizedBox(
                            height: 15,
                          ),
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!, width: 1),
                            borderRadius: BorderRadius.circular(15.0)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here...',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(fontSize: 14)),
                              ),
                            ),
                            Container(
                              color: Colors.lightBlue,
                              child: MaterialButton(
                                onPressed: ()
                                {
                                  SocialCubit.get(context).sendMessage(receiverId: userModel.uId!, dateTime: DateTime.now().toString(), text: messageController.text,);
                                },
                                minWidth: 1,
                                child: Icon(
                                  Icons.send,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                fallback: (context)=>Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget buildMessage(MessageModel model)=>Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          )),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text('${model.text}'),
    ),
  );
  Widget buildMyMessage(MessageModel model)=>Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.2),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          )),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text('${model.text}'),
    ),
  );
}
