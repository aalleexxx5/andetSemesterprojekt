package sample;


import java.util.Calendar;
import java.util.HashMap;

/**
 * Created by Alex on 08/05/2017.
 */
public class Order {
    private HashMap<ProductList,Double> productPriceMap;
    private int orderNumber;
    private double price;
    private Calendar date;
    private OrderStatus status;

    public Order(HashMap<ProductList, Double> productPriceMap, int orderNumber, double price) {
        this.productPriceMap = productPriceMap;
        this.orderNumber = orderNumber;
        this.price = price;
        this.status = OrderStatus.AWAITING_PAYMENT;
        this.date = Calendar.getInstance();
    }

    /**
     * Returns the list of products referenced in this order mapped to the price of the products.
     * @return A HashMap consisting of a {@link ProductList} mapped to the price, when it item was purchased.
     */
    public HashMap<ProductList, Double> getProductPriceMap() {
        return productPriceMap;
    }

    /**
     * A unique order number used for identifying a specific order.
     * @return the unique order number.
     */
    public int getOrderNumber() {
        return orderNumber;
    }

    /**
     * Returns the total price of the order.
     * @return The sum of all products in the order at the time it was placed.
     */
    public double getPrice() {
        return price;
    }

    /**
     * Returns the date for the placement of the order.
     * @return A {@link Calendar} object storing the time of order placement.
     */
    public Calendar getDate() {
        return date;
    }

    /**
     * Returns the status of the order.
     * @return A {@link OrderStatus}
     * @see OrderStatus
     */
    public OrderStatus getStatus() {
        return status;
    }

    /**
     * Sets the status of the order.
     * @param status An {@link OrderStatus} for the order.
     */
    public void setStatus(OrderStatus status) {
        this.status = status;
    }
}
