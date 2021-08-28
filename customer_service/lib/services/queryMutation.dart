class QueryMutation {

  String signUp(String username, String password) {
    return '''
  mutation SignUp{
  signUp(input: { fields: { username: "$username", password: "$password" } } 
 ) {
   viewer{
    user{
      id
      createdAt
  }
  sessionToken
  }
 }
}
''';
  }
}
