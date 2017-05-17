package Model.Product;

/**
 * Created by Alex on 08/05/2017.
 */
public class Product {
	private String name;
	private String category;
	//Product description...
	private int productID;
	private double price; //TODO: Decimal type instead of a double. To avoid floating point math errors
	
	public Product(String name, String category, int productID, double price) {
		this.name = name;
		this.category = category;
		this.productID = productID;
		this.price = price;
	}
	
	/**
	 * Returns the product name.
	 *
	 * @return A string representation of the product name.
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * Returns the unique id of the product.
	 *
	 * @return the product ID.
	 */
	public int getProductID() {
		return productID;
	}
	
	/**
	 * Returns the price of the product.
	 *
	 * @return Product price.
	 */
	public double getPrice() {
		return price;
	}
	
	/**
	 * Returns the product category as a string. Valid product categories are stored in the database.
	 *
	 * @return The category in which this product belongs.
	 */
	public String getCategory() {
		return category;
	}
}
