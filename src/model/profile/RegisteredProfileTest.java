package model.profile;

import model.product.Product;
import org.junit.Before;
import org.junit.Test;
import testUtils.GenerationUtils;

import java.util.Collections;
import java.util.HashMap;

import static org.junit.Assert.*;

/**
 * Created by Alex on 23/05/2017.
 */
public class RegisteredProfileTest {
	@Before
	public void Setup() {
		
	}
	
	@Test
	public void getName() throws Exception {
		RegisteredProfile profileUnderTest = generateRegisteredProfileWithNoOrders();
		assertNotNull("GetName must never be null", profileUnderTest.getName());
		assertTrue("Name field must have a space and conform to the following regex: \\D{2,20} .+", profileUnderTest.getName().matches("\\D{2,20} .+"));
		//TODO: Write more tests here
		
	}
	
	@Test
	public void getAddress() throws Exception {
		assertNotNull(generateRegisteredProfileWithNoOrders().getAddress());
	}
	
	@Test
	public void getPhone() throws Exception {
		assertNotNull(generateRegisteredProfileWithNoOrders().getPhone());
	}
	
	@Test
	public void getEmail() throws Exception {
		assertNotNull(generateRegisteredProfileWithNoOrders().getEmail());
	}
	
	@Test
	public void getProcessedOrders() throws Exception {
		RegisteredProfile profileWithoutOrders = generateRegisteredProfileWithNoOrders();
		assertNotNull(profileWithoutOrders.getProcessedOrders());
		RegisteredProfile profileWithOrders = generateRegisteredProfileWithOrders(2);
		assertNotNull("A profile with orders must not return a null", profileWithOrders.getProcessedOrders());
		
	}
	
	private RegisteredProfile generateRegisteredProfileWithNoOrders() {
		int profileID = GenerationUtils.generateUniqueInt(10000);
		String name = GenerationUtils.generateUniqueString(5) +" "+GenerationUtils.generateRandomString(5);
		String address = GenerationUtils.generateRandomString(10);
		String phone = String.valueOf(GenerationUtils.generateRandomIntByLength(8));
		String email = GenerationUtils.generateRandomString(10) +
				"@" + GenerationUtils.generateRandomString(10) +
				"." + GenerationUtils.generateRandomString(3);
		
		return new RegisteredProfile(profileID, name, address, phone, email);
	}
	
	private RegisteredProfile generateRegisteredProfileWithOrders(int amountOfOrders) {
		int profileID = GenerationUtils.generateUniqueInt(10000);
		String name = GenerationUtils.generateUniqueString(5) +" "+GenerationUtils.generateRandomString(5);
		String address = GenerationUtils.generateRandomString(10);
		String phone = String.valueOf(GenerationUtils.generateRandomIntByLength(8));
		String email = GenerationUtils.generateRandomString(10) +
				"@" + GenerationUtils.generateRandomString(10) +
				"." + GenerationUtils.generateRandomString(3);
		
		Order[] orders = new Order[amountOfOrders];
		for (int i = 0; i < amountOfOrders; i++) {
			orders[i] = generateUniqueOrder();
		}
		return new RegisteredProfile(profileID, name, address, phone, email, orders);
	}
	
	private Order generateUniqueOrder() {
		int orderId = GenerationUtils.generateUniqueInt(10000);
		int orderPrice = GenerationUtils.generateRandomInt(8000);
		
		return new Order(new HashMap<Product, Double>(), orderId, orderPrice);
	}
}