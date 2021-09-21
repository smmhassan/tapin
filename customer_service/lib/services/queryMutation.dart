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

  String getUser() {
    return '''
    query GetCurrentUser {
      viewer {
        sessionToken
        user {
          id
          objectId
        }
      }
    }
    ''';
  }

  String getUserDP(String id) {
    return '''
    query GetDP {
	    user(id: "$id") {
		    displayPicture {
          url
        }
	    }
    }
    ''';
  }

  String signIn(String username, String password) {
    return '''
    mutation LogIn{
      logIn(input: {
        username: "$username"
        password: "$password"
      }){
        viewer{
          user{
            id
            createdAt
            updatedAt
            username
          }
          sessionToken
        }
      }
    }
    ''';
  }

  String getAllOrgs() {
    return '''
    {
	    organizations {
		    count,
        edges {
          node {
            objectId
            name
            logo{
              url
            }
          }
        }
	    }
    }
    ''';
  }

  String getCategoryOrgs(String category) {
    return '''
    {
      organizations (
        where: {
          categories: {
            have: {
              name: {equalTo: "$category"}
            }
          }
        }
      ) {
		    count,
        edges {
          node {
            objectId
            name
            logo{
              url
            }
          }
        }
      }
    }
    ''';
  }

  String getAllCorrespondences(String userId) {
    return '''
{
  chats(
    where: {
      members: {
        have: {
          customer: { equalTo: true }
          user: { have: { objectId: { equalTo: "$userId" } } }
        }
      }
      correspondence: { exists: true }
    }
  ) {
    count
    edges {
      node {
        members(where: { user: { have: { employee: { exists: true } } } }) {
          edges {
            node {
              user {
                username
                employee {
                  organization {
                    name
                    logo {
                      url
                    }
                  }
                }
              }
            }
          }
        }
        correspondence {
          summary
        }
      }
    }
  }
}
    ''';
  }

  String getCategoryCorrespondences(String userId, String category) {
    return '''
{
  chats(
    where: {
      members: {
        have: {
          customer: { equalTo: true }
          user: { have: { objectId: { equalTo: "dIDTiwfkz0" } } }
        }
      }
      correspondence: {
        exists: true 
        have: {
          categories: {
            have: {
              name: {equalTo: "$category"}
            }
          }
        }
      }
    }
  ) {
    count
    edges {
      node {
        members(where: { user: { have: { employee: { exists: true } } } }) {
          edges {
            node {
              user {
                username
                employee {
                  organization {
                    name
                    logo {
                      url
                    }
                  }
                }
              }
            }
          }
        }
        correspondence {
          summary
        }
      }
    }
  }
}
    ''';
  }
}