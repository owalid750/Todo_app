import 'package:flutter/material.dart';

import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultbutton(
        {double width = double.infinity,
        double height = 40,
        Color color = Colors.red,
        String? text,
        double radius = 0,
        bool isUpperCase = true,
        VoidCallback? onpressed}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: onpressed,
        child: Text(
          isUpperCase ? text!.toUpperCase() : text!,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

Widget defaultform({
  String? label,
  String? text,
  Icon? prefxicon,
  InputBorder? border,
  Widget? suffex,
  String? validatemsg,
  Key? key,
  bool securetext = false,
  TextEditingController? controller,
  VoidCallback? suffexpressed,
  String? val,
}) =>
    TextFormField(
      onChanged: (val){

      },
      autovalidateMode: AutovalidateMode.always,
      controller: controller,
      key: key,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatemsg;
        }
        return null;
      },
      obscureText: securetext,
      decoration: InputDecoration(
        labelText: label,
        border: border,
        hintText: text,
        prefixIcon: prefxicon,
        suffixIcon: suffex,
      ),
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model["id"].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).delData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 10, 99, 172),
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${model['title']}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  Text(
                    "${model['date']}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 70,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .UpdateData(status: 'done', id: model['id']);
                      
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .UpdateData(status: 'archive', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.grey,
                ))
          ],
        ),
      ),
    ),
  );
}


 

Widget myDivider() {
  return Padding(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Divider(
      color: Colors.grey,
      thickness: 1,
    ),
  );
}

void navigateTo(context, Widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
