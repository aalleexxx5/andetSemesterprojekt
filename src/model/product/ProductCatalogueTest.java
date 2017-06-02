package model.product;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;

import static org.junit.Assert.*;

/**
 * Created by Mattias on 24/05/2017.
 */
public class ProductCatalogueTest {
	@Test
	public void getExtraServices() {
		ArrayList<Product> productArray = new ArrayList<>();
		Product p1 = new Product("MacBook Pro", "computer", 1, 1000);
		Product p2 = new Product("iPad", "tablet", 2, 600);
		ExtraServices e1 = new ExtraServices("laptop sleeve", "computer", 3, 100);
		ExtraServices e2 = new ExtraServices("tablet cover", "tablet", 4, 80);
		ExtraServices e3 = new ExtraServices("tablet smart cover", "tablet", 5, 120);
		productArray.add(p1);
		productArray.add(p2);
		productArray.add(e1);
		productArray.add(e2);
		productArray.add(e3);
		ProductCatalogue productCatalogue = new ProductCatalogue(productArray);
		
		assertNotNull(productCatalogue.getExtraServices(new Product[0]));
		assertTrue("Product should have exactly one extra service: " + productCatalogue.getExtraServices(new Product[]{p1}).size(), productCatalogue.getExtraServices(new Product[]{p1}).size() == 1);
		assertTrue(productCatalogue.getExtraServices(new Product[]{p2}).size() == 2);
		assertTrue(productCatalogue.getExtraServices(new Product[]{p1, p2}).size() == 3);
	}
}