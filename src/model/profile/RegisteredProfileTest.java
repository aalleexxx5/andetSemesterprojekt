package model.profile;

import model.product.Product;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;

import static org.junit.Assert.*;

/**
 * Created by Alex on 23/05/2017.
 */
public class RegisteredProfileTest {
	
	RegisteredProfile generateRegisteredProfileWithNoOrders(){
		//TODO: Make Unique
		return new RegisteredProfile(15,"name","address", "12345678", "e@mail.com");
	}
	RegisteredProfile generateRegisteredProfileWithOrders(){
		//TODO: Make Unique
		return new RegisteredProfile(15,"name","address", "12345678", "e@mail.com",new Order[]{generateUniqueOrder()});
	}
	
	Order generateUniqueOrder(){
		return new Order(new HashMap<Product, Double>(),125,15.5);
		//TODO: Unique
	}
	
	String generateUniqueString(){
		//TODO
		throw new UnsupportedOperationException();
	}
	
	String generateUniqueInt(){
		//TODO
		throw new UnsupportedOperationException();
	}
	
	@Before
	public void Setup(){
		
	}
	
	@Test
	public void getName() throws Exception {
		RegisteredProfile profileUnderTest = generateRegisteredProfileWithNoOrders();
		assertNotNull("GetName must never be null",profileUnderTest.getName());
		assertTrue("Name field must have a space and conform to the following regex: /D{2,20} .+", profileUnderTest.getName().matches("/D{2,20} .+"));
		//TODO: Write more tests here
		
	}
	
	@Test
	public void getAddress() throws Exception {
		
	}
	
	@Test
	public void getPhone() throws Exception {
		
	}
	
	@Test
	public void getEmail() throws Exception {
		
	}
	
	@Test
	public void getProcessedOrders() throws Exception {
		RegisteredProfile profileWithoutOrders = generateRegisteredProfileWithNoOrders();
		assertNull("If no orders exists, null must be returned",profileWithoutOrders.getProcessedOrders());
		RegisteredProfile profileWithOrders = generateRegisteredProfileWithOrders();
		assertNotNull("A profile with orders must not return a null",profileWithOrders.getProcessedOrders());
		
	}
}