  // used with dio for convert a single value
  T convertMapToModel<T>(
      T Function(Map<String, dynamic> map) fromJson, Map response) {
    return fromJson((response).cast());
  }

  // used with dio for convert a List of value
  List<T> convertListToModel<T>(
      T Function(Map<String, dynamic> map) fromJson, List data) {
    return data.map((e) => fromJson((e as Map).cast())).toList();
  }