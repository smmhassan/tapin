import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class QueryMutation {
  String signUp(
      String username, String password, String email, String displayName) {
    return '''
  mutation SignUp{
  signUp(input: { fields: 
  { username: "$username", 
  password: "$password", 
  email: "$email", 
  displayName: "$displayName",
  } } 
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

  String upDateDisplay(String displayUrl, String googleID) {
    return '''mutation UpdateDisplay {
  updateDisplayPicture(
  googleID: "$googleID", 
  fields: { 
  displayPicture: {url: displayUrl} 
  }) {
  updatedAt
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

  String updatePassword(String username, String password) {
    return '''
     mutation UpdatePassword{
  user(username: "$username" )(input: { fields: 
  { 
  password: "$password",
  } } 
 ) {
   viewer{
    user{
      id
      updatedAt
  }
  sessionToken
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

  // organizations -------------------------------------------------------------

  String getOrgs(List<String> categories, String sort, String search) {
    String categoriesInsertion = "";
    String searchInsertion = "";
    String insertion = "";
    if (categories.isNotEmpty || search.isNotEmpty || sort.isNotEmpty) {
      if (categories.isNotEmpty || search.isNotEmpty) {
        if (categories.isNotEmpty) {
          for (String category in categories) {
            categoriesInsertion += '''{name: {equalTo: "$category"}},''';
          }
          categoriesInsertion =
              '''categories: {have: {OR: [$categoriesInsertion]}}''';
        }
        if (search.isNotEmpty) {
          searchInsertion = '''name: {matchesRegex: "$search", options: "i"}''';
        }
        insertion += '''where: {$categoriesInsertion$searchInsertion}''';
      }
      if (sort.isNotEmpty) {
        insertion += '''order: $sort''';
      }
      insertion = '''($insertion)''';
    }
    //print(insertion);
    return '''
    {
      organizations $insertion {
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

  String getOrgByID(String id) {
    return '''
{
  organization(id: "$id") {
    name
    logo {
      url
    }
  }
}
    ''';
  }

  String getFAQS(String id) {
    return '''
{
  organization(id: "$id") {
    #name
    #logo {
    #  url
    #}
    faq {
      edges {
        node {
          objectId
        	question
          shortAnswer
          fullAnswer
        }
      }
    }
  }
}
    ''';
  }

  // correspondences -----------------------------------------------------------

  String getAllCorrespondences(String userId) {
    return '''
{
  userchats(
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
          objectId
          summary
        }
      }
    }
  }
}
    ''';
  }

  String getCategoryCorrespondences(String userId, List<String> categories) {
    String insertion = "";
    for (String category in categories) {
      insertion += '''{name: {equalTo: "$category"}},''';
    }
    insertion = '''[$insertion]''';
    return '''
{
  userchats(
    where: {
      members: {
        have: {
          customer: { equalTo: true }
          user: { have: { objectId: { equalTo: "$userId" } } }
        }
      }
      correspondence: {
        exists: true 
        have: {
          categories: {
            have: {
              OR: $insertion
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

  String getCorrespondences(
      String userId, List<String> categories, String search, String text) {
    String categoriesInsertion = "";
    String searchInsertion = "";
    String insertion = "";
    if (categories.isNotEmpty || search.isNotEmpty) {
      if (categories.isNotEmpty) {
        for (String category in categories) {
          categoriesInsertion += '''{name: {equalTo: "$category"}},''';
        }
      }
      if (search.isNotEmpty) {
        searchInsertion =
            '''summary: {matchesRegex: "$search", options: "i"}''';
      }
      categoriesInsertion =
          '''categories: {have: {OR: [$categoriesInsertion]}}''';
      insertion = '''have: {$categoriesInsertion $searchInsertion}''';
    }
    return '''
{
  userchats(
    where: {
      members: {
        have: {
          customer: { equalTo: true }
          user: { have: { objectId: { equalTo: "$userId" } } }
        }
      }
      correspondence: {
        exists: true 
        $insertion
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

  // categories ----------------------------------------------------------------

  String getAllCategories() {
    return '''
{
  categories {
    count
    edges {
      node {
        name
      }
    }
  }
}
    ''';
  }

  String getAllGoogleIDs() {
    return '''
{
  user {
    count
    edges {
      node {
        googleID
      }
    }
  }
}
    ''';
  }
}
