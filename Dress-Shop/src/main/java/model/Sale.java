package model;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
public class Sale {
    private int id;
    private String invoiceNo;
    private int userId;
    private BigDecimal total;
    private Date createdAt;
    private List<SaleItem> items;
    public int getId(){ return id; }
    public void setId(int id){ this.id = id; }
    public String getInvoiceNo(){ return invoiceNo; }
    public void setInvoiceNo(String invoiceNo){ this.invoiceNo = invoiceNo; }
    public int getUserId(){ return userId; }
    public void setUserId(int userId){ this.userId = userId; }
    public BigDecimal getTotal(){ return total; }
    public void setTotal(BigDecimal total){ this.total = total; }
    public Date getCreatedAt(){ return createdAt; }
    public void setCreatedAt(Date createdAt){ this.createdAt = createdAt; }
    public List<SaleItem> getItems(){ return items; }
    public void setItems(List<SaleItem> items){ this.items = items; }
}
