package model.product;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 */
public class ProductCatalogue {
	private ArrayList<Product> products;
	private ArrayList<ExtraServices> extraServicesList;
	
	public ProductCatalogue(ArrayList<Product> products) {
		this.products = products;
		extraServicesList = new ArrayList<>();
		
		for (Product product : products) {
			if (product instanceof ExtraServices)
				extraServicesList.add((ExtraServices) product);
		}
		this.products.removeAll(extraServicesList);
	}
	
	public ArrayList<Product> getProducts() {
		return products;
	}
	
	public void addProduct(Product p) {
		products.add(p);
	}
	
	public ArrayList<ExtraServices> getExtraServices(Product[] productsInCart) {
		ArrayList<ExtraServices> extraServicesForProductList = new ArrayList<>();
		for (Product product : productsInCart) {
			for (ExtraServices extraServices : extraServicesList) {
				if (product.getCategory().equals(extraServices.getCategory())) {
					if (!extraServicesForProductList.contains(extraServices)) {
						extraServicesForProductList.add(extraServices);
					}
				}
			}
		}
		return extraServicesForProductList;
	}
	//NOTE search might need to be moved to Database.
	//TODO: Search goes here
}
