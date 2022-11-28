import ballerina/http;
import ballerinax/github;
import ballerina/io;
//import ballerinax/googleapis.sheets as sheets;

configurable string authToken = ?;
# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {
    resource function get repositories() returns error? {
        github:ConnectionConfig config = {
            auth: {
                token:authToken
            }
        };
    github:Client|error githubClient = new (config);
    if githubClient is github:Client {
        github:SearchResult response = check githubClient->search("<org name> <text prefix>",github:SEARCH_TYPE_REPOSITORY,100);
        github:Issue[]|github:User[]|github:Organization[]|github:Repository[]|github:PullRequest[] result = response.results;
            if result is github:Repository[]{
                foreach github:Repository repo in result {
                io:println(repo.name);
            } 
        }
    }
    }
}
