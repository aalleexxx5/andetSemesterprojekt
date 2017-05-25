package model.profile;

import model.product.Cart;
import model.product.Product;
import model.serviceMannager.ProfileType;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by Mattias on 24/05/2017.
 */
public class ProfileTest {
    @Test
    public void getCart() throws Exception {
        Product p1 = new Product("MacBook Pro", "computer", 1, 1000);
        Profile profile = new Profile(1, ProfileType.VISITOR);

        assertNotNull(profile.getCart());
        assertEquals("The cart is not empty",0, profile.getCart().getProducts().length);

        profile.getCart().addProduct(p1, 1);

        assertEquals("The cart does not contain a product", 1, profile.getCart().getProducts().length);
    }
}