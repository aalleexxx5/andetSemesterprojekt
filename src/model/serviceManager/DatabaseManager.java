package model.serviceManager;

import model.product.Product;
import model.profile.RegisteredProfile;
import model.serviceManager.blueprints.AbstractDatabaseImplementation;
import model.serviceManager.databases.postgresql;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 * This class contains all communication with the database.
 * Since there currently is no database, all the methods are placeholders and returns values for testing purposes.
 */
public class DatabaseManager extends postgresql
{
	// Tags: Constructors
	public DatabaseManager()
	{
		if(Requirements() == false)
			System.exit(0);

	}

	public DatabaseManager( String Username, String Password,
							String Url, String Port,
							String Database )
	{
		InitialiseDb( Username, Password,
					  Url, Port,
					  Database );

		generateConnectionString();
	}
	
	
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
		
		RegisteredProfile[] registered = null; //ourDatabase.SelectUsers();
		
		if (registered == null)
			return null;
		
		System.out.print("Test: \r\n");
		// Better options to get it done, but it's a project.
		for (RegisteredProfile profile : registered) {
			System.out.print("Found : " + profile.toString());
			
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
		
		
		return false;
	}

	/*
	*   Temp test value:


	*/
	
	/**
	 * Returns the full list of all products.
	 *
	 *
	 *
	 * @return an array of products.
	 */
	public ArrayList<Product> getProductList()
	{
		return get_sql_Products();
	}
	
	/**
	 * Add a product to the database
	 *
	 * @param p The product to add.
	 */
	public boolean addProduct( Product p )
	{
		return insert_sql_product( p.getName(),
								   p.getPrice(),
								   p.getCategory() );
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
	public String[] getProductCategories()
	{
		return get_sql_ProductCategories();
	}
	
	public void unregisterProfile(RegisteredProfile profile) {
		throw new UnsupportedOperationException("Not yet implemented");
	}

}
