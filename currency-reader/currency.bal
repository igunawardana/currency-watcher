import ballerina/config;
import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerinax/docker;

endpoint http:Listener currencyListenerEp {
    port: 9090
};

endpoint http:Client fixerClientEp {
    url: "http://data.fixer.io"
};

@docker:Config {
    name: "currency-watcher",
    push: true,
    tag: "$env{DOCKER_IMAGE_TAG}",
    buildImage: true,
    registry: "$env{DOCKERHUB_REGISTRY}",
    username: "$env{DOCKERHUB_USERNAME}",
    password: "$env{DOCKERHUB_PASSWORD}",
    baseImage: "$env{DOCKER_BASE_IMAGE}"
}
@http:ServiceConfig {
    basePath: "/currency"
}
service<http:Service> currency bind currencyListenerEp {

    @http:ResourceConfig {
        path: "/"
    }
    getAllCurrencies(endpoint caller, http:Request request) {
        string context = "/api/latest";
        string accessKey = "?access_key=" + config:getAsString("FIXERIO_ACCESS_KEY");

        log:printInfo("URL: " + context + "{keyLength:" + accessKey.length() + "}");

        var resp = fixerClientEp->get(context + accessKey);

        match resp {
            http:Response response => {
                log:printInfo("Response received from backend ");
                var respondVar = caller->respond(response);
            }
            error err => {
                log:printError("Error from backend ", err = ());

                error? er = check err.cause;

                string | () erStr = check er;
                json errorResponseJson = {
                    "status": false,
                    "message": err.message,
                    "cause": erStr
                };
                log:printInfo(errorResponseJson.toString());
                http:Response backendResponse;
                backendResponse.setJsonPayload(errorResponseJson, contentType = "application/json");
                backendResponse.statusCode = 500;
                var respondVar = caller->respond(backendResponse);
            }
        }
    }
}
