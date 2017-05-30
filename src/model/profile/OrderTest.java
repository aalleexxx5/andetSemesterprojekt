package model.profile;

import com.sun.deploy.ui.ProgressDialog;
import model.product.Product;
import org.junit.Test;

import java.util.HashMap;

import static org.junit.Assert.*;

/**
 * Created by sam on 23-05-2017.
 */
public class OrderTest {

    @Test
    public void validOrder() throws Exception {
        try {
            new Order(new HashMap<Product, Double>(),42,42.42);
            fail("Creating an invalid Order throws IllegalArgumentException");
        }catch (IllegalArgumentException e) {
        }
    }


    @Test
    public void getProductPriceMap() throws Exception {

    }

    @Test
    public void getOrderNumber() throws Exception {

    }

    @Test
    public void getPrice() throws Exception {

    }

    @Test
    public void getDate() throws Exception {

    }

    @Test
    public void getStatus() throws Exception {

    }

    @Test
    public void setStatus() throws Exception {

    }

}