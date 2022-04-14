class User {
  User(this._username, this._email, this._password);

  final String _username;
  final String _email;
  final String _password;

  getUsername() => this._username;

  getPassword() => this._password;

  getEmail() => this._email;
}