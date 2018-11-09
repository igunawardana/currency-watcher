import ballerina/config;
import ballerina/http;
import ballerina/log;
import ballerina/io;

endpoint http:Listener currencyListenerEp {
    port: 9090
};

endpoint http:Client fixerClientEp {
    url: "http://data.fixer.io"
};

@http:ServiceConfig {
    basePath: "/currency"
}
service<http:Service> currency bind currencyListenerEp {

    # A resource is an invokable API method
    # Accessible at '/hello/sayHello
    #'caller' is the client invoking this resource 

    # + caller - Server Connector
    # + request - Request

    @http:ResourceConfig {
        path: "/"
    }
    getAllCurrencies (endpoint caller, http:Request request) {
        string context = "/api/lates";
        string accessKey = "?access_key="+ config:getAsString("FIXERIO_ACCESS_KEY");

        log:printInfo("URL: "+ context+accessKey);
        http:Response backendResponse;
        error backendError;

        var resp = fixerClientEp -> get(context+accessKey);

        match resp {
            http:Response response => {
                log:printInfo("Response received from backend ");

                json tempJson = check response.getJsonPayload();
                var respondVar = caller -> respond(response);
            }
            error err => {
                log:printError("Error from backend ", err = ());
                io:println(err);

                error? er = check err.cause;

                string|() erStr = check er;
                json errorResponseJson = {
                    "status": false,
                    "message":err.message,
                    "cause": erStr
                };
                log:printInfo(errorResponseJson.toString());
                backendResponse.setJsonPayload(errorResponseJson, contentType = "application/json");
                backendResponse.statusCode = 500;
                var respondVar = caller -> respond(backendResponse);
            }
        }
    }
}
