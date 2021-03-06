package model.product;

import java.util.HashMap;

/**
 * Created by Alex on 08/05/2017.
 */
public class Cart {
	private HashMap<Product, Integer> products;
	
	public Cart() {
		products = new HashMap<Product, Integer>();
	}
	
	/**
	 * Adds a product to the list.
	 *
	 * @param p      the product to add
	 * @param amount The amount of products to add.
	 */
	public void addProductToCart(Product p, int amount) {
		if (amount <= 0) {
			throw new IllegalArgumentException("You cannot add 0 products to your cart!");
		}
		
		if (products.containsKey(p)) {
			products.put(p, products.get(p) + amount);
		} else {
			products.put(p, amount);
		}
	}
	
	/**
	 * Removes a product from the list.
	 *
	 * @param p the product to remove.
	 */
	public void removeProduct(Product p) {
		if (!products.containsKey(p)) {
			throw new IllegalArgumentException("You cannot remove a non-existent product");
		}
		products.remove(p);
	}
	
	/**
	 * Decrements the amount of products in the list. If more products are to be removed than exists, the product is removed.
	 *
	 * @param p      The product to decrement.
	 * @param amount Det amount of products to subtract from the list.
	 */
	public void decrementProduct(Product p, int amount) {
		if (!products.containsKey(p)) {
			throw new IllegalArgumentException("You cannot decrement a non-existent product!");
		}
		if (products.get(p) - amount < 1) {
			removeProduct(p);
		} else {
			products.put(p, products.get(p) - amount);
		}
	}
	
	/**
	 * Returns the list of products stores, without the associated amounts.
	 *
	 * @return The stored products.
	 */
	public Product[] getProducts() {
		return products.keySet().toArray(new Product[0]);
	}
	
	/**
	 * Returns a map of products to integers.
	 *
	 * @return The stored products mapped to integers.
	 */
	public HashMap<Product, Integer> getProductMap() {
		return products;
	}
}
