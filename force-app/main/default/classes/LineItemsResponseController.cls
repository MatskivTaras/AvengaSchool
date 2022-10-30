public class LineItemsResponseController {
    @AuraEnabled
    public static List<LineItemWrapper> getLineItemWrappers(String responseResult) {
        List<LineItemWrapper> lineItemWrappers = new List<lineItemWrapper>();
        lineItemWrappers = (List<lineItemWrapper>)JSON.deserialize(
            responseResult,
            List<lineItemWrapper>.class
        );

        Integer key = 50000001;
        for (lineItemWrapper wrappers : lineItemWrappers) {
            wrappers.Id = String.valueOf(key);
            key++;
        }

        return lineItemWrappers;
    }

    @AuraEnabled
    public static String getResponseResult(){
        HttpResponse httpResponse = LineItemsCallout.getCallout();

        String tmpResponseResult = '';
        if (httpResponse.getStatusCode() == 200) {
            tmpResponseResult = httpResponse.getBody();
        } else {
            tmpResponseResult = httpResponse.getStatus();
        }

        return tmpResponseResult;
    }
}