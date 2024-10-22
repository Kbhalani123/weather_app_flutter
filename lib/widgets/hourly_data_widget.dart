import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_flutter/controllers/global_controller.dart';
import 'package:weather_app_flutter/models/weather_data_hourly.dart';
import 'package:weather_app_flutter/utils/custom_colors.dart';

class HourlyDataWidget extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;

  HourlyDataWidget({Key? key, required this.weatherDataHourly}) : super(key: key);

  RxInt cardIndex = GlobalController().getIndex();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly.hourly.length > 12 ? 12 : weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          final hourlyData = weatherDataHourly.hourly[index];

          // Default values if properties are null
          final temp = hourlyData.temp ?? 0;
          final timestamp = hourlyData.dt ?? 0;
          final weatherIcon = hourlyData.weather?.isNotEmpty == true ? hourlyData.weather![0].icon : 'default';

          return Obx(() => GestureDetector(
            onTap: () {
              cardIndex.value = index;
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(left: 20, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.5, 0),
                    blurRadius: 20,
                    spreadRadius: 1,
                    color: CustomColors.dividerLine.withAlpha(150),
                  ),
                ],
                gradient: cardIndex.value == index
                    ? const LinearGradient(colors: [
                  CustomColors.firstGradientColor,
                  CustomColors.secondGradientColor,
                ])
                    : null,
              ),
              child: HourlyDetails(
                index: index,
                cardIndex: cardIndex.toInt(),
                temp: temp,
                timestamp: timestamp,
                weatherIcon: weatherIcon,
              ),
            ),
          ));
        },
      ),
    );
  }
}

class HourlyDetails extends StatelessWidget {
  final int temp;
  final int timestamp;
  final int cardIndex;
  final int index;
  final String weatherIcon;

  HourlyDetails({
    Key? key,
    required this.timestamp,
    required this.temp,
    required this.index,
    required this.cardIndex,
    required this.weatherIcon,
  }) : super(key: key);

  String getTime(int timestamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('jm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            getTime(timestamp),
            style: TextStyle(
              color: cardIndex == index ? Colors.white : CustomColors.textColorBlack,
            ),
          ),
        ),
        Container(
          child: Image.asset(
            'assets/weather/$weatherIcon.png',
            height: 40,
            width: 40,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 40); // Fallback for missing icons
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            '$temp',
            style: TextStyle(
              color: cardIndex == index ? Colors.white : CustomColors.textColorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
