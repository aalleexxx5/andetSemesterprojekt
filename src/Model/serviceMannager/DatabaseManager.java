package model.serviceMannager;

import model.Product.Product;
import model.Profile.RegisteredProfile;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 * This class contains all communication with the database.
 * Since there currently is no database, all the methods are placeholders and returns values for testing purposes.
 */
public class DatabaseManager {
	Database ourDatabase = new File_database();
	
	/**
	 * Attempts to log a user in. The database will return the profile data if username and password matches a profile in the database.
	 *
	 * @param username The username of the profile.
	 * @param password The password of the profile.
	 * @return A {@link RegisteredProfile} if one with the gived credentials exists in the database. null otherwise.
	 */
	public RegisteredProfile login(String username, String password) {
		/*
		 Remember to escape username and password when changing to Database Quarry.
         If you do not know what escaping is or how to do it, ask Alex or Google.
         If you do not know how to implement it, try with a prepaired statement.
         Test if it works with what's inside the diamond brackets as username and password <' OR '1'='1' -->
         Good luck.
          */
		
		// temporary
		
		RegisteredProfile[] registered = ourDatabase.SelectUsers();
		
		if (registered == null)
			return null;
		
		System.out.print("Test: \r\n");
		// Better options to get it done, but it's a project.
		for (RegisteredProfile profile : registered) {
			System.out.print("Found : " + profile.toString());
			
			
			if (profile.getUsername().equals(username) &&
					profile.getPassword().equals(password)) {
				return profile;
			}
		}
		
		return null;
	}
	
	/**
	 * Returns whether a username is in use in the database.
	 *
	 * @param username The username to check
	 * @return True, if the name is in use.
	 */
	public boolean userExists(String username) {
		throw new UnsupportedOperationException("Not yet implemented");
	}
	
	/**
	 * Registers a user profile Returns true if successful
	 *
	 * @param profile  The profile to register.
	 * @param username The username for the profile.
	 * @param password The password of the profile.
	 * @return True if the operation was successful, false otherwise.
	 */
	public boolean registerProfile(RegisteredProfile profile, String username, String password) {
		//Remember to check for username and password validity.
		profile.setUsername(username);
		profile.setPassword(password);
		
		return ourDatabase.InsertProfile(profile);
	}
	
	/**
	 * Returns the full list of all products.
	 *
	 * @return an array of products.
	 */
	public ArrayList<Product> getProductList() {
		//Temp test value:
		
		ArrayList<Product> list = new ArrayList<>();
		list.add(new Product("fan", "electronics", 345, 244.95));
		list.add(new Product("tablefan", "electronics", 346, 245.95));
		list.add(new Product("monitor", "monitors", 423, 1499.95));
		list.add(new Product("super tablefan", "electronics", 346, 449.99));
		list.add(new Product("standing fan", "electronics", 120, 499.95));
		list.add(new Product("mini monitor", "monitors", 424, 526.45));
		list.add(new Product("LED TV", "monitors", 425, 2499.95));
		return list;
		//throw new UnsupportedOperationException("Not yet implemented");
	}
	
	/**
	 * Add a product to the database
	 *
	 * @param p The product to add.
	 */
	public boolean addProduct(Product p) {
		throw new UnsupportedOperationException("Not implemented yet.");
	}
	
	/**
	 * Remove a product from the database
	 *
	 * @param p the product to remove.
	 */
	public boolean removeProduct(Product p) {
		throw new UnsupportedOperationException("Not yet implemented");
	}
	
	/**
	 * Returns all valid product categories.
	 *
	 * @return a string array containing all product categories.
	 */
	public String[] getProductCategories() {
		//Temp return value for testing:
		return new String[]{"monitors", "electronics"};
		
	}
	
	public void unregisterProfile(RegisteredProfile profile) {
		throw new UnsupportedOperationException("Not yet implemented");
	}
}
