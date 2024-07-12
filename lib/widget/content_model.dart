class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent({required this.description,required this.image,required this.title});
}

List<UnboardingContent> contents=[
  UnboardingContent(
      description: 'Pick your food from our menu\n    Choose your favorite cook',
      image: 'images/screen1.png',
      title: 'Select from Our\n  Best Menu'
  ),
  UnboardingContent(
      description: 'You can choose to pay\n    by cash or UPI',
      image: 'images/screen2.png',
      title: 'Easy and online payment'
  ),
  UnboardingContent(
      description: 'Choose for delivery or\n    collecting yourself',
      image: 'images/screen3.png',
      title: 'Quick delivery at your DoorStep'
  )
];