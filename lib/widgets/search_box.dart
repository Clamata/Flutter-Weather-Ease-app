import 'package:flutter/material.dart';
import 'package:weather_app/weather_service/data_fetcher_service.dart';
import '../../constants.dart';
//Allows to search cities for weather forecast
class SearchBox extends StatefulWidget {
  const SearchBox(
      {super.key,
        this.width,
        required this.dataFetcher,
        required this.city});
  final DataFetcher dataFetcher;
  final double? width;
  final String city;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}
class _SearchBoxState extends State<SearchBox> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget.width ?? MediaQuery.of(context).size.width / 1.4;
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
              width: widget.width,
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
                    hintText: widget.city,
                    hintStyle: getLowText(context, color: Colors.white30)),
                controller: controller,
                onChanged: (city) async {
                  widget.dataFetcher.city = city;
                  widget.dataFetcher.latitude = null;
                  widget.dataFetcher.longitude = null;
                  await widget.dataFetcher.fetchData();
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}