import 'package:flutter/material.dart';

class ConverterProvider extends ChangeNotifier {
  String _selectedCategory = 'Length';
  String _fromUnit = '';
  String _toUnit = '';
  String _inputValue = '';
  String _outputValue = '';

  final Map<String, List<String>> _units = {
    'Length': ['Meter', 'Kilometer', 'Centimeter', 'Millimeter', 'Mile', 'Yard', 'Foot', 'Inch'],
    'Area': ['Square Meter', 'Square Kilometer', 'Square Centimeter', 'Square Millimeter', 'Square Mile', 'Square Yard', 'Square Foot', 'Square Inch', 'Hectare', 'Acre'],
    'Volume': ['Cubic Meter', 'Cubic Centimeter', 'Liter', 'Milliliter', 'Gallon', 'Quart', 'Pint', 'Cup'],
    'Weight': ['Kilogram', 'Gram', 'Milligram', 'Metric Ton', 'Pound', 'Ounce', 'Stone'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Time': ['Second', 'Minute', 'Hour', 'Day', 'Week', 'Month', 'Year'],
    'Speed': ['Meter/Second', 'Kilometer/Hour', 'Mile/Hour', 'Knot', 'Foot/Second'],
    'Energy': ['Joule', 'Kilojoule', 'Calorie', 'Kilocalorie', 'Watt-hour', 'Kilowatt-hour', 'Electron-volt', 'BTU'],
    'Data': ['Bit', 'Byte', 'Kilobyte', 'Megabyte', 'Gigabyte', 'Terabyte', 'Petabyte'],
  };

  String get selectedCategory => _selectedCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get inputValue => _inputValue;
  String get outputValue => _outputValue;
  Map<String, List<String>> get units => _units;
  List<String> get categories => _units.keys.toList();
  List<String> get currentUnits => _units[_selectedCategory] ?? [];

  ConverterProvider() {
    _fromUnit = _units[_selectedCategory]?.first ?? '';
    _toUnit = _units[_selectedCategory]?.last ?? '';
  }

  void setCategory(String category) {
    if (_units.containsKey(category)) {
      _selectedCategory = category;
      _fromUnit = _units[category]?.first ?? '';
      _toUnit = _units[category]?.last ?? '';
      convert();
      notifyListeners();
    }
  }

  void setFromUnit(String unit) {
    if (_units[_selectedCategory]?.contains(unit) ?? false) {
      _fromUnit = unit;
      convert();
      notifyListeners();
    }
  }

  void setToUnit(String unit) {
    if (_units[_selectedCategory]?.contains(unit) ?? false) {
      _toUnit = unit;
      convert();
      notifyListeners();
    }
  }

  void setInputValue(String value) {
    _inputValue = value;
    convert();
    notifyListeners();
  }

  void convert() {
    if (_inputValue.isEmpty) {
      _outputValue = '';
      return;
    }

    try {
      double input = double.parse(_inputValue);
      double result = 0;

      // Convert input to base unit
      double baseValue = _convertToBase(input, _fromUnit);

      // Convert from base unit to target unit
      result = _convertFromBase(baseValue, _toUnit);

      _outputValue = result.toString();
    } catch (e) {
      _outputValue = 'Error';
    }
  }

  double _convertToBase(double value, String unit) {
    switch (_selectedCategory) {
      case 'Length':
        return _convertLengthToMeter(value, unit);
      case 'Area':
        return _convertAreaToSquareMeter(value, unit);
      case 'Volume':
        return _convertVolumeToLiter(value, unit);
      case 'Weight':
        return _convertWeightToKilogram(value, unit);
      case 'Temperature':
        return _convertTemperatureToCelsius(value, unit);
      case 'Time':
        return _convertTimeToSecond(value, unit);
      case 'Speed':
        return _convertSpeedToMeterPerSecond(value, unit);
      case 'Energy':
        return _convertEnergyToJoule(value, unit);
      case 'Data':
        return _convertDataToByte(value, unit);
      default:
        return value;
    }
  }

  double _convertFromBase(double value, String unit) {
    switch (_selectedCategory) {
      case 'Length':
        return _convertMeterToLength(value, unit);
      case 'Area':
        return _convertSquareMeterToArea(value, unit);
      case 'Volume':
        return _convertLiterToVolume(value, unit);
      case 'Weight':
        return _convertKilogramToWeight(value, unit);
      case 'Temperature':
        return _convertCelsiusToTemperature(value, unit);
      case 'Time':
        return _convertSecondToTime(value, unit);
      case 'Speed':
        return _convertMeterPerSecondToSpeed(value, unit);
      case 'Energy':
        return _convertJouleToEnergy(value, unit);
      case 'Data':
        return _convertByteToData(value, unit);
      default:
        return value;
    }
  }

  // Length conversions
  double _convertLengthToMeter(double value, String unit) {
    switch (unit) {
      case 'Meter': return value;
      case 'Kilometer': return value * 1000;
      case 'Centimeter': return value * 0.01;
      case 'Millimeter': return value * 0.001;
      case 'Mile': return value * 1609.34;
      case 'Yard': return value * 0.9144;
      case 'Foot': return value * 0.3048;
      case 'Inch': return value * 0.0254;
      default: return value;
    }
  }

  double _convertMeterToLength(double value, String unit) {
    switch (unit) {
      case 'Meter': return value;
      case 'Kilometer': return value / 1000;
      case 'Centimeter': return value / 0.01;
      case 'Millimeter': return value / 0.001;
      case 'Mile': return value / 1609.34;
      case 'Yard': return value / 0.9144;
      case 'Foot': return value / 0.3048;
      case 'Inch': return value / 0.0254;
      default: return value;
    }
  }

  // Area conversions
  double _convertAreaToSquareMeter(double value, String unit) {
    switch (unit) {
      case 'Square Meter': return value;
      case 'Square Kilometer': return value * 1000000;
      case 'Square Centimeter': return value * 0.0001;
      case 'Square Millimeter': return value * 0.000001;
      case 'Square Mile': return value * 2589988.11;
      case 'Square Yard': return value * 0.83612736;
      case 'Square Foot': return value * 0.09290304;
      case 'Square Inch': return value * 0.00064516;
      case 'Hectare': return value * 10000;
      case 'Acre': return value * 4046.8564224;
      default: return value;
    }
  }

  double _convertSquareMeterToArea(double value, String unit) {
    switch (unit) {
      case 'Square Meter': return value;
      case 'Square Kilometer': return value / 1000000;
      case 'Square Centimeter': return value / 0.0001;
      case 'Square Millimeter': return value / 0.000001;
      case 'Square Mile': return value / 2589988.11;
      case 'Square Yard': return value / 0.83612736;
      case 'Square Foot': return value / 0.09290304;
      case 'Square Inch': return value / 0.00064516;
      case 'Hectare': return value / 10000;
      case 'Acre': return value / 4046.8564224;
      default: return value;
    }
  }

  // Volume conversions
  double _convertVolumeToLiter(double value, String unit) {
    switch (unit) {
      case 'Cubic Meter': return value * 1000;
      case 'Cubic Centimeter': return value * 0.001;
      case 'Liter': return value;
      case 'Milliliter': return value * 0.001;
      case 'Gallon': return value * 3.78541;
      case 'Quart': return value * 0.946353;
      case 'Pint': return value * 0.473176;
      case 'Cup': return value * 0.24;
      default: return value;
    }
  }

  double _convertLiterToVolume(double value, String unit) {
    switch (unit) {
      case 'Cubic Meter': return value / 1000;
      case 'Cubic Centimeter': return value / 0.001;
      case 'Liter': return value;
      case 'Milliliter': return value / 0.001;
      case 'Gallon': return value / 3.78541;
      case 'Quart': return value / 0.946353;
      case 'Pint': return value / 0.473176;
      case 'Cup': return value / 0.24;
      default: return value;
    }
  }

  // Weight conversions
  double _convertWeightToKilogram(double value, String unit) {
    switch (unit) {
      case 'Kilogram': return value;
      case 'Gram': return value * 0.001;
      case 'Milligram': return value * 0.000001;
      case 'Metric Ton': return value * 1000;
      case 'Pound': return value * 0.453592;
      case 'Ounce': return value * 0.0283495;
      case 'Stone': return value * 6.35029;
      default: return value;
    }
  }

  double _convertKilogramToWeight(double value, String unit) {
    switch (unit) {
      case 'Kilogram': return value;
      case 'Gram': return value / 0.001;
      case 'Milligram': return value / 0.000001;
      case 'Metric Ton': return value / 1000;
      case 'Pound': return value / 0.453592;
      case 'Ounce': return value / 0.0283495;
      case 'Stone': return value / 6.35029;
      default: return value;
    }
  }

  // Temperature conversions
  double _convertTemperatureToCelsius(double value, String unit) {
    switch (unit) {
      case 'Celsius': return value;
      case 'Fahrenheit': return (value - 32) * 5 / 9;
      case 'Kelvin': return value - 273.15;
      default: return value;
    }
  }

  double _convertCelsiusToTemperature(double value, String unit) {
    switch (unit) {
      case 'Celsius': return value;
      case 'Fahrenheit': return (value * 9 / 5) + 32;
      case 'Kelvin': return value + 273.15;
      default: return value;
    }
  }

  // Time conversions
  double _convertTimeToSecond(double value, String unit) {
    switch (unit) {
      case 'Second': return value;
      case 'Minute': return value * 60;
      case 'Hour': return value * 3600;
      case 'Day': return value * 86400;
      case 'Week': return value * 604800;
      case 'Month': return value * 2592000; // Assuming 30 days
      case 'Year': return value * 31536000; // Assuming 365 days
      default: return value;
    }
  }

  double _convertSecondToTime(double value, String unit) {
    switch (unit) {
      case 'Second': return value;
      case 'Minute': return value / 60;
      case 'Hour': return value / 3600;
      case 'Day': return value / 86400;
      case 'Week': return value / 604800;
      case 'Month': return value / 2592000; // Assuming 30 days
      case 'Year': return value / 31536000; // Assuming 365 days
      default: return value;
    }
  }

  // Speed conversions
  double _convertSpeedToMeterPerSecond(double value, String unit) {
    switch (unit) {
      case 'Meter/Second': return value;
      case 'Kilometer/Hour': return value * 0.277778;
      case 'Mile/Hour': return value * 0.44704;
      case 'Knot': return value * 0.514444;
      case 'Foot/Secon' :  return value * 0.44704;
      case 'Knot': return value * 0.514444;
      case 'Foot/Second': return value * 0.3048;
      default: return value;
    }
  }

  double _convertMeterPerSecondToSpeed(double value, String unit) {
    switch (unit) {
      case 'Meter/Second': return value;
      case 'Kilometer/Hour': return value / 0.277778;
      case 'Mile/Hour': return value / 0.44704;
      case 'Knot': return value / 0.514444;
      case 'Foot/Second': return value / 0.3048;
      default: return value;
    }
  }

  // Energy conversions
  double _convertEnergyToJoule(double value, String unit) {
    switch (unit) {
      case 'Joule': return value;
      case 'Kilojoule': return value * 1000;
      case 'Calorie': return value * 4.184;
      case 'Kilocalorie': return value * 4184;
      case 'Watt-hour': return value * 3600;
      case 'Kilowatt-hour': return value * 3600000;
      case 'Electron-volt': return value * 1.602176634e-19;
      case 'BTU': return value * 1055.06;
      default: return value;
    }
  }

  double _convertJouleToEnergy(double value, String unit) {
    switch (unit) {
      case 'Joule': return value;
      case 'Kilojoule': return value / 1000;
      case 'Calorie': return value / 4.184;
      case 'Kilocalorie': return value / 4184;
      case 'Watt-hour': return value / 3600;
      case 'Kilowatt-hour': return value / 3600000;
      case 'Electron-volt': return value / 1.602176634e-19;
      case 'BTU': return value / 1055.06;
      default: return value;
    }
  }

  // Data conversions
  double _convertDataToByte(double value, String unit) {
    switch (unit) {
      case 'Bit': return value / 8;
      case 'Byte': return value;
      case 'Kilobyte': return value * 1024;
      case 'Megabyte': return value * 1048576;
      case 'Gigabyte': return value * 1073741824;
      case 'Terabyte': return value * 1099511627776;
      case 'Petabyte': return value * 1125899906842624;
      default: return value;
    }
  }

  double _convertByteToData(double value, String unit) {
    switch (unit) {
      case 'Bit': return value * 8;
      case 'Byte': return value;
      case 'Kilobyte': return value / 1024;
      case 'Megabyte': return value / 1048576;
      case 'Gigabyte': return value / 1073741824;
      case 'Terabyte': return value / 1099511627776;
      case 'Petabyte': return value / 1125899906842624;
      default: return value;
    }
  }
}

