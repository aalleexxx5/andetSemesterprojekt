package sample;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 * This class contains all communication with the database.
 * Since there currently is no database, all the methods are placeholders and returns values for testing purposes.
 */
public class DatabaseManager {

    /**
     * Attempts to log a user in. The database will return the profile data if username and password matches a profile in the database.
     * @param username The username of the profile.
     * @param password The password of the profile.
     * @return A {@link RegisteredProfile} if one with the gived credentials exists in the database. null otherwise.
     */
    RegisteredProfile login(String username, String password){
        /*
         Remember to escape username and password when changing to Database Quarry.
         If you do not know what escaping is or how to do it, ask Alex or Google.
         If you do not know how to implement it, try with a prepaired statement.
         Test if it works with what's inside the diamond brackets as username and password <' OR '1'='1' -->
         Good luck.
          */

        //Temporary return values for testing:
        if (username.equals("deadbeef")&&password.equals("deadbeef")){
            return new RegisteredProfile(0xDEAD_BEEF, "dead beef", "Local butchery, butcheryway 666 Butchery City", "37359285", "dead@beef.com", null);
        }if (username.equals("admin")&&password.equals("admin")){
            return new RegisteredProfile(0xDEAD_BEF0, "Admin", "Wherever Admin lives", "12121212", "admin@admin.com", null, ProfileType.ADMIN);
        }
        if (username.equals("deafface")&&password.equals("deafface")){
            return new RegisteredProfile(0xDEAF_FACE, "deaf face", "SilentStreet 15, Silent Hill", "37360749", "deaf@face.org", null);
        }
        return null;
    }

    /**
     * Returns whether a username is in use in the database.
     * @param username The username to check
     * @return True, if the name is in use.
     */
    public boolean userExixts(String username){
        throw new UnsupportedOperationException("Not yet implemented");
    }

    /**
     * Registers a user profile Returns true if successful
     * @param profile The profile to register.
     * @param username The username for the profile.
     * @param password The password of the profile.
     * @return True if the operation was successful, false otherwise.
     */
    public boolean RegisterProfile(RegisteredProfile profile, String username, String password){
         //Remember to check for username and password validity.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    /**
     * Returns the full list of all products.
     * @return an array of products.
     */
    public ArrayList<Product> getProductList(){
        //Temp test value:

        ArrayList<Product> list = new ArrayList<>();
        list.add(new Product("tablefan","electronics", 345, 244.95));
        list.add(new Product("monitor", "monitors", 423, 1499.95));
        list.add(new Product("super tablefan","electronics", 346, 449.99));
        return list;
        //throw new UnsupportedOperationException("Not yet implemented");
    }

    /**
     * Add a product to the database
     * @param p The product to add.
     */
    public void addProduct(Product p){
        throw new UnsupportedOperationException("Not implemented yet.");
    }

    /**
     * Remove a product from the database
     * @param p the product to remove.
     */
    public void removeProduct(Product p){
        throw new UnsupportedOperationException("Not yet implemented");
    }

    /**
     * Returns all valid product categories.
     * @return a string array containing all product categories.
     */
    public String[] getProductCategories(){
        //Temp return value for testing:
        return new String[] {"monitors", "electronics"};

    }
}
