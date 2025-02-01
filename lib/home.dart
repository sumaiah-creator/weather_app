import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart'; // Ensure this file has your API key

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final WeatherFactory wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather("Warangal");
  }

  void _fetchWeather(String city) {
    wf.currentWeatherByCityName(city).then((w) {
      setState(() {
        _weather = w;
      });
    });

    wf.fiveDayForecastByCityName(city).then((f) {
      setState(() {
        _forecast = f;
      });
    });
  }

  void _onSearchSubmitted(String city) {
    _fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null || _forecast == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _searchbar(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _locationHeader(),
            SizedBox(
              height: 5,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _extraInfo(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _forecastList(),
          ],
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: GoogleFonts.poppins(fontSize: 30,fontWeight: FontWeight.bold),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            Text(
              DateFormat("d.M.y").format(now),
              style: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)} °C",
      style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)} °C",
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)} °C",
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchbar() {
    return Container(
      height: 50,
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          fillColor: Color.fromARGB(255, 219, 218, 218),
          hintText: 'Search city',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onSubmitted: _onSearchSubmitted,
      ),
    );
  }

  Widget _forecastList() {
    // Filter to get unique dates for the next 5 days
    final uniqueForecasts = <DateTime, Weather>{};
    for (var weather in _forecast!) {
      final date = DateTime(weather.date!.year, weather.date!.month, weather.date!.day);
      if (!uniqueForecasts.containsKey(date)) {
        uniqueForecasts[date] = weather;
      }
      if (uniqueForecasts.length >= 5) break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 0.90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: uniqueForecasts.length,
          itemBuilder: (context, index) {
            final forecast = uniqueForecasts.values.elementAt(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _weather = forecast;
                });
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(forecast.date!),
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                      Image.network(
                        "http://openweathermap.org/img/wn/${forecast.weatherIcon}@2x.png",
                        height: 50,
                      ),
                      Text(
                        "${forecast.temperature!.celsius!.toStringAsFixed(0)} °C",
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
