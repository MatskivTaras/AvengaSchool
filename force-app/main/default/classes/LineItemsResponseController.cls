public class LineItemsResponseController {
    @AuraEnabled public static String jsonString{get; set;}

    @AuraEnabled
    public static List<LineItemWrapper> getLineItemWrappers() {
        List<LineItemWrapper> lineItemWrappers = new List<lineItemWrapper>();
        HttpResponse httpResponse = LineItemsCallout.getCallout();

        if (httpResponse.getStatusCode() != 200) {
            jsonString = httpResponse.getStatus();
            return lineItemWrappers;
        }

        lineItemWrappers = (List<lineItemWrapper>)JSON.deserialize(
            httpResponse.getBody(),
            List<lineItemWrapper>.class
        );

        jsonString = httpResponse.getBody();

        Integer key = 50000001;
        for (lineItemWrapper wrappers : lineItemWrappers) {
            wrappers.Id = String.valueOf(key);
            key++;
        }

        return lineItemWrappers;
    }

    @AuraEnabled
    public static String getResponseResult(){
        return jsonString;
    }
}