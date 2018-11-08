import ballerina/http;
import ballerina/io;
import ballerina/test;

# Before Suite Function
@test:BeforeSuite
function beforeSuiteServiceFunc () {
    io:println("Before Suite function executing");
}

# Test function
@test:Config
function testGetAllCurrenciesSuccess () {
    io:println("Testing Get All Currencies Success scenario");
    test:assertTrue(callgetAllCurrencyService(), msg = "Failed to get 200 status code");
}

# After Suite Function
@test:AfterSuite
function afterSuiteServiceFunc () {
    io:println("After Suite function executing");
}

function callgetAllCurrencyService() returns boolean {
    endpoint http:Client getAllCurrenciesEp {
        url: "http://localhost:9090/currency/"
    };

    var res = getAllCurrenciesEp->get("/");

    match res {
        http:Response response => { 
            log:printInfo("No error found in the service call, returned with status code: "+response.statusCode);
            string|error s = response.getTextPayload();
            io:println(s);
            return response.statusCode == 200;
        }
        error err => {
            io:println("Error found ", err);
        }
    } 
    return false;
}
