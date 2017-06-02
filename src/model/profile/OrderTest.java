package model.profile;

import com.sun.deploy.ui.ProgressDialog;
import model.product.Product;
import org.junit.Test;
import testUtils.GenerationUtils;

import java.util.HashMap;

import static org.junit.Assert.*;

/**
 * Created by sam on 23-05-2017.
 */
public class OrderTest {
	private Order generateRandomOrder() {
		HashMap<Product, Double> orderMap = new HashMap<>();
		Product testProduct = GenerationUtils.generateRandomProduct();
		orderMap.put(testProduct, testProduct.getPrice());
		return new Order(orderMap, GenerationUtils.generateRandomInt(100), testProduct.getPrice());
	}
	
	@Test
	public void validOrder() throws Exception {
		try {
			new Order(new HashMap<Product, Double>(), 42, 42.42);
			fail("Creating an invalid Order throws IllegalArgumentException");
		} catch (IllegalArgumentException e) {
		}
	}
	
	@Test
	public void getProductPriceMap() throws Exception {
		assertNotNull("ProductPriceMap must not be null", generateRandomOrder().getProductPriceMap());
	}
	
	@Test
	public void getOrderNumber() throws Exception {
		assertNotNull("OrderNumber must not be null", generateRandomOrder().getOrderNumber());
	}
	
	@Test
	public void getPrice() throws Exception {
		assertNotNull("Price must not be null", generateRandomOrder().getPrice());
	}
	
	@Test
	public void getDate() throws Exception {
		assertNotNull("Date must not be null", generateRandomOrder().getDate());
	}
	
	@Test
	public void getStatus() throws Exception {
		assertNotNull("Status must not be null", generateRandomOrder().getStatus());
	}
	
	@Test
	public void setStatus() throws Exception {
		
	}
}