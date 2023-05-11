class User {
  final String imagePath;
  final String name;
  final String email;
  final String age;
  final String height;
  final String weight;
  final String bmi;
  final String bloodGroup;
  final String allergies;
  final String healthConditions;
  final String gender;

  const User(
      {required this.age,
      required this.height,
      required this.weight,
      required this.bmi,
      required this.bloodGroup,
      required this.allergies,
      required this.healthConditions,
      required this.imagePath,
      required this.name,
      required this.email,
      required this.gender});

  User copy(
          {String? imagePath,
          String? name,
          String? email,
          String? age,
          String? height,
          String? weight,
          String? bmi,
          String? bloodGroup,
          String? allergies,
          String? healthConditions,
          String? gender}) =>
      User(
          imagePath: imagePath ?? this.imagePath,
          name: name ?? this.name,
          email: email ?? this.email,
          age: age ?? this.age,
          height: height ?? this.height,
          weight: weight ?? this.weight,
          bmi: bmi ?? this.bmi,
          bloodGroup: bloodGroup ?? this.bloodGroup,
          allergies: allergies ?? this.allergies,
          healthConditions: healthConditions ?? this.healthConditions,
          gender: gender ?? this.gender);

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'age': age,
        'height': height,
        'weight': weight,
        'bmi': bmi,
        'bloodGroup': bloodGroup,
        'allergies': allergies,
        'healthConditions': healthConditions,
        'gender': gender,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        age: json['age'],
        height: json['height'],
        weight: json['weight'],
        bmi: json['bmi'],
        bloodGroup: json['bloodGroup'],
        allergies: json['allergies'],
        healthConditions: json['healthConditions'],
        gender: json['gender'],
      );
}
