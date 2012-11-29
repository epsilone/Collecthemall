namespace java com.funcom.ccg.thrift
namespace as3 com.funcom.ccg.thrift

typedef string uuid

struct Player {
    1: required uuid userId,
}

/*
    All request to the server should pass, in the headers, the session returned by the Authentication service.
*/
service Game {
    Player getPlayer(1:uuid userId),
}