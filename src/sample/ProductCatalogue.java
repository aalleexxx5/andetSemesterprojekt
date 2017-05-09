package sample;

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

    //TODO: Search goes here
}
