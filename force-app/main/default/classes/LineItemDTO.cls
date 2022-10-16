public class LineItemDTO {
    public String name {get; set;}
    public Id productId {get; set;}
    public Double quantity {get; set;}

    public LineItemDTO(String name, Id productId, Double quantity) {
        this.name = name;
        this.productId = productId;
        this.quantity = quantity;
    }
}