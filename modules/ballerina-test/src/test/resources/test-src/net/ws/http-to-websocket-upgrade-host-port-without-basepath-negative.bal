import ballerina.net.http;
import ballerina.net.ws;

@http:configuration {
    basePath:"/test",
    port:9090,
    webSocket:@http:webSocket {
                  upgradePath:"/ws",
                  serviceName:"wsService"
              }
}
service<http> httpService {

    @http:resourceConfig {
        path:"/world",
        methods:["POST","GET","PUT","My"]
    }
    resource testResource(http:Connection conn, http:Request req) {

        http:Response resp = {};
        string payload = req.getStringPayload();
        println(payload);
        resp.setStringPayload("I received");
        _ = conn.respond(resp);
    }
}

@ws:configuration {
    port:9090,
    subProtocols:["xml, json"],
    idleTimeoutInSeconds:5
}
service<ws> wsService  {

    resource onOpen(ws:Connection conn) {
        println("New WebSocket connection: " + conn.getID());
    }

    resource onTextMessage(ws:Connection conn, ws:TextFrame frame) {
        println(frame.text);
        conn.pushText(frame.text);
    }

    resource onIdleTimeout(ws:Connection conn) {
        println("Idle timeout: " + conn.getID());
    }
}