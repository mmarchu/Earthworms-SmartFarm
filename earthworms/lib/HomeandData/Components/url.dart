class ApiUrl {
  //Login
  static const String ANDlogin =
      'http://10.0.2.2:4000/api/auth/login'; // 'http://192.168.1.40:4000/api/auth/login';
  static const String IOSlogin =
      'http://127.0.0.1:4000/api/auth/login'; // 'http://192.168.1.40:4000/api/auth/login';

  //Register
  static const String ANDregister =
      'http://10.0.2.2:4000/api/auth/register'; // 'http://192.168.1.40:4000/api/auth/register'
  static const String IOSregister =
      'http://127.0.0.1:4000/api/auth/register'; // 'http://192.168.1.40:4000/api/auth/register'

  //Get One User
  static const String ANDgetoneuser =
      'http://10.0.2.2:4000/api/auth/getoneuser'; // 'http://192.168.1.40:4000/api/auth/getoneuser'
  static const String IOSgetoneuser =
      'http://127.0.0.1:4000/api/auth/getoneuser'; // 'http://192.168.1.40:4000/api/auth/getoneuser'

  //Create Sensor
  static const String ANDcreatesensor =
      'http://10.0.2.2:4000/api/sensor/create'; //  'http://192.168.1.40:4000/api/sensor/create'
  static const String IOScreatesensor =
      'http://127.0.0.1:4000/api/sensor/create'; // 'http://192.168.1.40:4000/api/sensor/create'

  //Delete Sensor
  static const String ANDdeletesensor =
      'http://10.0.2.2:4000/api/sensor/delete'; // 'http://192.168.1.40:4000/api/sensor/delete'
  static const String IOSdeletesensor =
      'http://127.0.0.1:4000/api/sensor/delete'; // 'http://192.168.1.40:4000/api/sensor/delete';

  //Update Sensor Name
  static const String ANDupdateSensorName =
      'http://10.0.2.2:4000/api/sensor/update'; // 'http://192.168.1.40:4000/api/sensor/update'
  static const String IOSupdateSensorName =
      'http://127.0.0.1:4000/api/sensor/update'; // 'http://192.168.1.40:4000/api/sensor/update'

  //WaterPump
  static const String ANDwaterpump =
      'http://10.0.2.2:4000/api/gpio/state'; // 'http://192.168.1.40:4000/api/gpio/state;
  static const String IOSwaterpump =
      'http://127.0.0.1:4000/api/gpio/state'; // 'http://192.168.1.40:4000/api/gpio/state';

  //Get Data TimeSeries
  static const String ANDgetTimeseries =
      'http://10.0.2.2:4000/api/timeSeries/get'; // 'http://192.168.1.40:4000/api/timeSeries/get'
  static const String IOSgetTimeseries =
      'http://127.0.0.1:4000/api/timeSeries/get'; // 'http://192.168.1.40:4000/api/timeSeries/get'
}
