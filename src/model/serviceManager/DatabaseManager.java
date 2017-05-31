package model.serviceManager;

import model.product.Product;
import model.profile.Profile;
import model.profile.RegisteredProfile;
import model.serviceManager.objects.Products;
import model.serviceManager.objects.Profiles;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Alex on 08/05/2017.
 * This class contains all communication with the database.
 * Since there currently is no database, all the methods are placeholders and returns values for testing purposes.
 */
public class DatabaseManager implements DatabaseInterface
{
	Connection connector = null;

	// Tags: Constructors
	public DatabaseManager() {

	}
	
	public DatabaseManager(String Username, String Password,
	                       String Url, String Port,
	                       String Database)
	{

		
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

		RegisteredProfile registered = Profiles.getModelProfile(new Profiles(username, password, this));
		
		if (registered == null)
			return null;

		return registered;
	}
	
	/**
	 * Registers a user profile Returns true if successful
	 *
	 * @param profile  The profile to register.
	 * @param username The username for the profile.
	 * @param password The password of the profile.
	 * @return True if the operation was successful, false otherwise.
	 */
	public boolean registerProfile(RegisteredProfile profile, String username, String password)
	{
		//Remember to check for username and password validity.
		return Profiles.RegisterProfile();
	}

	public boolean unregisterProfile( RegisteredProfile profile )
	{
		return Profiles.UnregisterProfile();
	}

	/**
	 * Returns whether a username is in use in the database.
	 *
	 * @param username The username to check
	 * @return True, if the name is in use.
	 */
	public boolean userExists(String username)
	{
		return Profiles.ExistProfile();
	}

	/**
	 * Returns the full list of all products.
	 *
	 * @return an array of products.
	 */
	public ArrayList<Product> getProductList()
	{
		ArrayList<Product> prodList = new ArrayList<>();

		// Retrieves all product_identities in the Database
		List<Integer> identities = Products.getProductIdentities(this);

		// For each of them, get their columns.
		// Temp : Could be made alot easier
		for( int i : identities )
		{
			if ( i == -1 )
				continue;

			// gets the products, attributes
			Products p = new Products( i, this );

			// Convert to a model product
			prodList.add( p.getModelProduct() );
		}

		return prodList;
	}
	
	/**
	 * Add a product to the database
	 *
	 * @param p The product to add.
	 */
	public boolean addProduct(Product p)
	{
		return Products.addProduct( p, this );
	}
	
	/**
	 * Remove a product from the database
	 *
	 * @param p the product to remove.
	 */
	public boolean removeProduct(Product p)
	{
		return Products.removeProduct(p, this);
	}
	
	/**
	 * Returns all valid product categories.
	 *
	 * @return a string array containing all product categories.
	 */
	public String[] getProductCategories()
	{

		return null;
	}

	// Objects
	@Override
	public Connection returnConnector()
	{
		return connector;
	}

	@Override
	public boolean Open()
	{
		try {
			connector = DriverManager.getConnection("jdbc:postgresql://localhost:5432/webshop_db",
					"postgres",
					"Epc63gez");
			return true;
		}
		catch (Exception ex)
		{

		}

		return false;
	}

	@Override
	public boolean Close()
	{
		try
		{
			connector.close();
			return true;
		}
		catch (Exception ex)
		{
			System.out.println(ex.getMessage());
		}

		return false;
	}
}
