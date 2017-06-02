package model.product;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by Musli on 23-05-2017.
 */
public class CartTest {
	Cart generateEmptyCart() {
		return new Cart();
	}
	
	Cart generateCartWithOneProduct() {
		Cart cartMock = new Cart();
		cartMock.addProductToCart(new Product("Toshiba 111", "PC", 47, 250.00), 5);
		return cartMock;
	}
	
	Cart generateCartWithProducts() {
		Cart cartMock = new Cart();
		cartMock.addProductToCart(new Product("Nvidia 1080", "GPU", 41, 1000), 1);
		cartMock.addProductToCart(new Product("Logitech 211", "Mouse", 22, 300), 1);
		return cartMock;
	}
	
	private Product generateProduct() {
		return new Product("Nvidia 1080", "GPU", 41, 1000);
	}
	
	@Test
	public void addProductToCart() throws Exception {
		Cart emptyCart = generateEmptyCart();
		try {
			emptyCart.addProductToCart(generateProduct(), 0);
			fail("Adding 0 products should throw an IllegalArgumentException");
		} catch (IllegalArgumentException e) {
			//Pass
		}
		try {
			emptyCart.addProductToCart(generateProduct(), -1);
			fail("Adding a negative amount of products should throw an IllegalArgumentException");
		} catch (IllegalArgumentException e) {
			//Pass
		}
		assertTrue("Cart must still be empty after failing to add a product", emptyCart.getProducts().length == 0);
		Product product = generateProduct();
		emptyCart.addProductToCart(product, 1);
		assertTrue("Cart must contain a product after adding one", emptyCart.getProducts().length == 1);
		emptyCart.addProductToCart(product, 1);
		assertTrue("Cart must increment the added product, if it alredy exists", emptyCart.getProductMap().get(product) == 2);
	}
	
	@Test
	public void removeProduct() throws Exception {
		Cart cartWithProducts = generateCartWithProducts();
		Product productToRemove = cartWithProducts.getProducts()[0];
		cartWithProducts.removeProduct(productToRemove);
		assertTrue("Cart must remove a product when removing one", cartWithProducts.getProducts().length == 1);
		try {
			cartWithProducts.removeProduct(productToRemove);
			fail("Removing a non-existent product, should throw an execption");
		} catch (IllegalArgumentException e) {
			//pass
		}
	}
	
	@Test
	public void decrementProduct() throws Exception {
		Cart emptyCart = generateEmptyCart();
		Product productToDecrement = generateProduct();
		try {
			emptyCart.decrementProduct(productToDecrement, 1);
			fail("Decrementing a non-existent product should throw an exception");
		} catch (IllegalArgumentException e) {
			//pass
		}
		Cart cartWithOneProduct = generateCartWithOneProduct();
		Product productToDecrement1 = cartWithOneProduct.getProducts()[0];
		int startingAmount = cartWithOneProduct.getProductMap().get(productToDecrement1);
		int amountToRemove = 1;
		cartWithOneProduct.decrementProduct(productToDecrement1, amountToRemove);
		assertTrue("Cart must decrement the product",
				cartWithOneProduct.getProductMap().get(productToDecrement1) == startingAmount - amountToRemove);
		
		Product productToRemove = cartWithOneProduct.getProducts()[0];
		int ProductAmount = cartWithOneProduct.getProductMap().get(productToRemove);
		cartWithOneProduct.decrementProduct(productToRemove, ProductAmount);
		assertTrue("Cart must remove a product when decrementing below 1 amount",
				cartWithOneProduct.getProducts().length == 0);
	}
	
	@Test
	public void getProducts() throws Exception {
		Cart cartWithOneProduct = generateCartWithOneProduct();
		Cart emptyCart = generateEmptyCart();
		assertNotNull("The product list returned must not be null", cartWithOneProduct.getProducts());
		assertNotNull("An empty cart must not return null when empty", emptyCart.getProducts());
	}
	
	@Test
	public void getProductMap() throws Exception {
		Cart cartUnderTest = generateCartWithProducts();
		assertNotNull("There must be products to get map", cartUnderTest.getProductMap());
	}
}