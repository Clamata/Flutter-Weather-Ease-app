import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../utils/constants.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width / 1.4) /
                  2,
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kSteelBlue, kDarkSteel],
                  ),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width / 15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 3))
                  ]),
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.clear();
                        },
                        icon: Icon(Icons.clear)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width / 15)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width / 15)),
                        borderSide: BorderSide(color: kDarkSteel, width: 3)),
                    labelText: 'Search city...',
                    labelStyle: getLowText(context),
                    hintText: context.watch<DataProvider>().city,
                    hintStyle: getLowText(context, color: Colors.white30)),
                controller: controller,
                onSubmitted: (city) async {
                  await context.read<DataProvider>().setCity(city);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
