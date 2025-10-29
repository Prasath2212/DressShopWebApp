package model;
import java.math.BigDecimal;
public class Product {
    private int id;
    private String sku;
    private String name;
    private BigDecimal price;
    private int stock;
    public int getId(){ return id; }
    public void setId(int id){ this.id = id; }
    public String getSku(){ return sku; }
    public void setSku(String sku){ this.sku = sku; }
    public String getName(){ return name; }
    public void setName(String name){ this.name = name; }
    public BigDecimal getPrice(){ return price; }
    public void setPrice(BigDecimal price){ this.price = price; }
    public int getStock(){ return stock; }
    public void setStock(int stock){ this.stock = stock; }
}
