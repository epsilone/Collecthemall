namespace java com.funcom.ccg.thrift
namespace as3 com.funcom.ccg.thrift

typedef string uuid


////////// AUTHENTICATION //////////


enum AuthStatus {
    SUCCESS = 1,
    CREATED = 2,    // implies success
    BANNED = 3,
    ERROR = 4,
}

struct AuthInfo {
    1: required uuid userId,
    2: required uuid session,
    3: required AuthStatus status,
}

// Add new authentication method depending on platform i.e. Android, HTML5
service Authentication {
    AuthInfo authenticate(1:string identifier, 2:string password),
    AuthInfo authenticateFacebook(1:string facebookId, 2:string facebookToken),
    AuthInfo authenticateIOS(1:string udid),
}

