class UserProfile{
  final String name;
  final String email;
  final String matricnum;
  final String phonenum;
  final String address;

  UserProfile({ required this.name, required this.email, required this.matricnum, required this.phonenum,required this.address});
  factory UserProfile.defaultInstance() {
    return UserProfile(name: '', email: '', matricnum: '', phonenum: '', address: '');
  }
}