class Country {
  const Country({required this.name, required this.code, required this.flag});

  final String name;
  final String code;
  final String flag;
}

const uae = Country(
  name: 'United Arab Emirates',
  code: '971',
  flag: 'assets/images/flag_uae.png',
);

// more countries can be added here
const countries = [uae];
