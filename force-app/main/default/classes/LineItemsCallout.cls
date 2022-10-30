public class LineItemsCallout {
    public static HttpResponse getCallout() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint('https://avenga-school.herokuapp.com/retrieve-data');
        httpRequest.setHeader('projectName', 'GroceryStore');
        
        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);

        return httpResponse;
    }
}