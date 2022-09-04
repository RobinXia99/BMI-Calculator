import 'dart:ffi';

import 'package:bmicalculator/main.dart';
import 'package:bmicalculator/recordModel.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _gender = null;
  double? _myBmi = null;
  bool _isShowingResult = false;
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  List<Record> _bmiRecords = [];

  void _selectGender(String props) {
    if (props == "Male") {
      setState(() {
        _gender = props;
      });
    } else if (props == "Female") {
      setState(() {
        _gender = props;
      });
    }
  }

  void _calculateBmi() {
    if (int.tryParse(_heightController.text) != null &&
        int.tryParse(_weightController.text) != null) {
      setState(() {
        _myBmi = int.parse(_weightController.text) /
            pow(int.parse(_heightController.text) / 100, 2);

        _bmiRecords.add(Record(_gender.toString(), _heightController.text,
            _weightController.text, _myBmi!.toStringAsFixed(1), 'yyyy-MM-dd'));
      });

      print(_bmiRecords[0]);

      Platform.isAndroid ? openDialog() : null;
    }
  }

  void _resetCalculation() {
    setState(() {
      _gender = null;
      _myBmi = null;
      _heightController.clear();
      _weightController.clear();
    });
  }

  _getBmiIndication() {
    if (_myBmi! < 18.5) {
      return "Underweight";
    } else if (_myBmi! >= 18.5 && _myBmi! <= 24.9) {
      return "Normal";
    } else if (_myBmi! >= 25 && _myBmi! <= 29.9) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  _getColorIndication(String bmi) {
    switch (bmi) {
      case "Underweight":
        return Color.fromARGB(255, 209, 88, 88);
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Color.fromARGB(255, 209, 88, 88);
      case "Obese":
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  void _removeItem(int index) {
    setState(() {
      _bmiRecords = List.from(_bmiRecords)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return isPortrait
        ? Container(
            margin: EdgeInsets.all(20.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 150,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: (_gender == "Male"
                                      ? Colors.blue.withOpacity(.6)
                                      : Colors.transparent),
                                  spreadRadius: 2)
                            ]),
                        child: ElevatedButton(
                            onPressed: () => _selectGender("Male"),
                            style: ElevatedButton.styleFrom(
                                primary: (_gender == "Male"
                                    ? Colors.blue.withOpacity(.6)
                                    : Colors.transparent)),
                            child: Text(
                              "Male",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            )),
                      )),
                  SizedBox(
                      width: 150,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: (_gender == "Female"
                                      ? Colors.pink.withOpacity(.6)
                                      : Colors.transparent),
                                  spreadRadius: 2)
                            ]),
                        child: ElevatedButton(
                            onPressed: () => _selectGender("Female"),
                            style: ElevatedButton.styleFrom(
                                primary: (_gender == "Female"
                                    ? Colors.pink.withOpacity(.6)
                                    : Colors.transparent)),
                            child: Text(
                              "Female",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            )),
                      )),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                    width: 350,
                    child: Platform.isAndroid
                        ? TextField(
                            controller: _heightController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Height in cm",
                                labelStyle: TextStyle(
                                    color: (_gender == "Male" ||
                                            _gender == "Female"
                                        ? (_gender == "Male"
                                            ? Colors.blue
                                            : Colors.pink)
                                        : Colors.black)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: (_gender == "Male" ||
                                                _gender == "Female"
                                            ? (_gender == "Male"
                                                ? Colors.blue
                                                : Colors.pink)
                                            : Colors.black)),
                                    borderRadius: BorderRadius.circular(50)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: (_gender == "Male" ||
                                                _gender == "Female"
                                            ? (_gender == "Male"
                                                ? Colors.blue
                                                : Colors.pink)
                                            : Colors.black)),
                                    borderRadius: BorderRadius.circular(50))),
                          )
                        : CupertinoTextField(
                            controller: _heightController,
                            placeholder: "Height in cm",
                            placeholderStyle: TextStyle(
                                color: (_gender == "Male" || _gender == "Female"
                                    ? (_gender == "Male"
                                        ? CupertinoColors.activeBlue
                                        : CupertinoColors.systemPink)
                                    : CupertinoColors.black)),
                            padding: EdgeInsets.all(12),
                          )),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                    width: 350,
                    child: Platform.isAndroid
                        ? TextField(
                            controller: _weightController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Weight in kg",
                                labelStyle: TextStyle(
                                    color: (_gender == "Male" ||
                                            _gender == "Female"
                                        ? (_gender == "Male"
                                            ? Colors.blue
                                            : Colors.pink)
                                        : Colors.black)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: (_gender == "Male" ||
                                                _gender == "Female"
                                            ? (_gender == "Male"
                                                ? Colors.blue
                                                : Colors.pink)
                                            : Colors.black)),
                                    borderRadius: BorderRadius.circular(50)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: (_gender == "Male" ||
                                                _gender == "Female"
                                            ? (_gender == "Male"
                                                ? Colors.blue
                                                : Colors.pink)
                                            : Colors.black)),
                                    borderRadius: BorderRadius.circular(50))),
                          )
                        : CupertinoTextField(
                            controller: _weightController,
                            placeholder: "Weight in kg",
                            placeholderStyle: TextStyle(
                                color: (_gender == "Male" || _gender == "Female"
                                    ? (_gender == "Male"
                                        ? CupertinoColors.activeBlue
                                        : CupertinoColors.systemPink)
                                    : CupertinoColors.black)),
                            padding: EdgeInsets.all(12),
                          )),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                    itemCount: _bmiRecords.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: (_bmiRecords[index].gender == "Male"
                            ? Colors.blue
                            : Colors.pink),
                        child: ListTile(
                          textColor: Colors.white,
                          title:
                              Text("BMI: ${_bmiRecords[index].bmi.toString()}"),
                          subtitle: Text(
                              "Height: ${_bmiRecords[index].height} cm Weight: ${_bmiRecords[index].weight} kg"),
                          trailing: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () => _removeItem(index),
                            child: Icon(Icons.delete,
                                color: (_bmiRecords[index].gender == "Male"
                                    ? Colors.blue
                                    : Colors.pink)),
                          ),
                        ),
                      );
                    }),
              ),
              Spacer(),
              SizedBox(
                width: 350,
                height: 50,
                child: Container(
                    child: Platform.isAndroid
                        ? ElevatedButton(
                            onPressed: () => (_myBmi == null
                                ? _calculateBmi()
                                : _resetCalculation()),
                            child: Text(
                                (_myBmi == null ? "Calculate" : "Recalculate"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                                primary:
                                    (_gender == "Male" || _gender == "Female"
                                        ? (_gender == "Male"
                                            ? Colors.blue
                                            : Colors.pink)
                                        : Colors.black),
                                shape: StadiumBorder()),
                          )
                        : CupertinoButton(
                            child: Text(
                                _myBmi == null ? "Calculate" : "Recalculate"),
                            color: (_gender == "Male" || _gender == "Female"
                                ? (_gender == "Male"
                                    ? CupertinoColors.activeBlue
                                    : CupertinoColors.systemPink)
                                : CupertinoColors.black),
                            onPressed: () => (_myBmi == null
                                ? _calculateBmi()
                                : _resetCalculation()))),
              ),
            ]),
          )
        : Container(
            child: Row(children: <Widget>[
              Image.network(
                  "https://c.tenor.com/yheo1GGu3FwAAAAC/rick-roll-rick-ashley.gif"),
              SizedBox(
                height: 200,
                width: 50,
              ),
              SizedBox(
                width: 300,
                child: Text("This app requires you to use Portrait mode."),
              )
            ]),
          );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Color.fromARGB(255, 28, 28, 28),
            content: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      child: Text(
                        "Your BMI is ${_myBmi!.toStringAsFixed(1)}",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Text(_getBmiIndication(),
                          style: TextStyle(
                              fontSize: 30,
                              color: _getColorIndication(_getBmiIndication()),
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )
                              ])),
                    ),
                    SizedBox(
                      child: Column(children: <Widget>[
                        Text(
                          "A normal BMI is between 18.5 - 24.9",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          "BMI does not consider muscle mass.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 248, 255, 36)),
                        )
                      ]),
                    )
                  ],
                )),
          ));

  Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Your BMI is ${_myBmi!.toStringAsFixed(1)}",
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          content: Text(_getBmiIndication(),
              style: TextStyle(
                  fontSize: 30,
                  color: _getColorIndication(_getBmiIndication()),
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ])),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }
}


// Column(
//             children: _bmiRecords.asMap().entries.map
//             ((element) => SizedBox(
//                     width: double.infinity,
//                     child: Card(
//                       child: ListTile(
//                         tileColor: (element.value.gender == "Male"
//                             ? Colors.blue
//                             : Colors.pink),
//                         textColor: Colors.white,
//                         title: Text("BMI: ${element.value.bmi.toString()}"),
//                         subtitle: Text(
//                             "Height: ${element.value.height} cm Weight: ${element.value.weight} kg"),
//                         trailing: ElevatedButton(onPressed: () => {}, child: Icon(Icons.delete),),
//                       ),
//                     )))
//                 .toList()),