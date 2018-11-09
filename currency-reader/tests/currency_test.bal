import ballerina/http;
import ballerina/io;
import ballerina/test;
import ballerina/system;

endpoint http:Client getAllCurrenciesEp {
    url: "http://localhost:9090/currency/"
};

# Before Suite Function
@test:BeforeSuite
function beforeSuiteServiceFunc () {
    io:println("Before Suite function executing");
}

# Test function
@test:Config
function testGetAllCurrenciesSuccess () {
    io:println("Testing Get All Currencies Success scenario");
    test:assertTrue(callgetAllCurrencyServiceSuccess(), msg = "Failed to get 200 status code");
}

#TODO
@test:Config
function testGetAllCurrenciesFailed() {
    test:assertFalse(false, msg = "Assertion Failed!");
}

# After Suite Function
@test:AfterSuite
function afterSuiteServiceFunc () {
    io:println("After Suite function executing");
}

function callgetAllCurrencyServiceSuccess() returns boolean {

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
