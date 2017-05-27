package gui;

import model.product.Cart;
import model.product.Product;

import java.util.ArrayList;

/**
 * Created by Alex on 27/05/2017.
 * This class shouldn't need to exist, yet here it is!
 * The reason this class exists is to allow for displaying the contents of the cart in a table.
 * JavaFX TableView does not provide a way to iterate through table indices and add values.
 */
public class CartTableEntry {
	private String name;
	private String category;
	private int amount;
	private double total;
	
	public static ArrayList<CartTableEntry> getCartList(Cart cart){
		ArrayList<CartTableEntry> cartTableEntries = new ArrayList<>();
		for (Product product : cart.getProductMap().keySet()) {
			cartTableEntries.add(new CartTableEntry(product.getName(),product.getCategory(),
					cart.getProductMap().get(product),product.getPrice()*cart.getProductMap().get(product)));
		}
		return cartTableEntries;
	}
	
	private CartTableEntry(String name, String category, int amount, double total) {
		this.name = name;
		this.category = category;
		this.amount = amount;
		this.total = total;
	}
	
	public String getName() {
		return name;
	}
	
	public String getCategory() {
		return category;
	}
	
	public int getAmount() {
		return amount;
	}
	
	public double getTotal() {
		return total;
	}
}
