class QueryMutation {

  String signUp(String username, String password, Object email) {
    return """
  mutation SignUp{
  signUp(input: {
  fields: {
  username: $username,
  password: $password,
  email: $email,
  }
  }){
  viewer{
  user{
  id
  createdAt
  }
  sessionToken
  }
  }
}
""";
  }
}
