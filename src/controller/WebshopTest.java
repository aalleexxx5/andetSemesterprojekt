package controller;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by Mattias on 25/05/2017.
 */
public class WebshopTest {
	@Test
	public void getCurrentProfile() throws Exception {
		Webshop webshop = new Webshop();
		
		assertNotNull(webshop.getCurrentProfile());
	}
	
	@Test
	public void showExtraServices() {
		Webshop webshop = new Webshop();
		
		assertNotNull(webshop.getProductCatalogue().getExtraServices(webshop.getCurrentProfile().getCart().
				getProducts()));
	}
}