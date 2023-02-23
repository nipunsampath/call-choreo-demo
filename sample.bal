import ballerina/http;

type RiskResponse record {
    boolean hasRisk;
};

type RiskRequest record {
    string ip;
};

type ipGeolocationResp record {
    string ip;
    string country_code2;
};

configurable string geoApiKey = ?;

service / on new http:Listener(8090) {
resource function post risk(@http:Payload RiskRequest req) returns RiskResponse|error? {

     string ip = req.ip;
     http:Client ipGeolocation = check new ("https://api.ipgeolocation.io");
     ipGeolocationResp geoResponse = check ipGeolocation->get(string `/ipgeo?apiKey=${geoApiKey}&ip=${ip}&fields=country_code2`);
     
     RiskResponse resp = {
          // hasRisk is true if the country code of the IP address is not the specified country code.
          hasRisk: geoResponse.country_code2 != "LK"
     };
     return resp;
}
}
