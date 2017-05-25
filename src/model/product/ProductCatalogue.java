package model.product;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 */
public class ProductCatalogue {
	ArrayList<Product> products;
	
	public ProductCatalogue(ArrayList<Product> products) {
		this.products = products;
	}
	
	public ArrayList<Product> getProducts() {
		return products;
	}
	
	public void addProduct(Product p) {
		products.add(p);
	}

	public ExtraServices[] getExtraServices(Product[] products) {
		throw new UnsupportedOperationException("Not implemented yet.");
	}
	
	//NOTE search might need to be moved to Database.
	//TODO: Search goes here
}
