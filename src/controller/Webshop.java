package controller;

import model.product.ExtraServices;
import model.product.Product;
import model.product.ProductCatalogue;
import model.profile.Profile;
import model.profile.RegisteredProfile;
import model.serviceManager.DatabaseManager;
import model.profile.ProfileType;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 */
public class Webshop {
	private DatabaseManager dbm;
	private RegisteredProfile loggedInProfile; //I would love to deprecate this.
	private Profile currentProfile;
	private ProductCatalogue productCatalogue;
	
	public Webshop() {
		currentProfile = new Profile(141, ProfileType.VISITOR);//TEMPORARY
		dbm = new DatabaseManager();
		productCatalogue = new ProductCatalogue(dbm.getProductList());
	}
	
	/**
	 * Attempts to log in the user with the given credentials.
	 *
	 * @param username The username to log in with.
	 * @param password The password to log in with.
	 * @return <code>true</code>, if a profile with the given credentials was found.
	 */
	public boolean login(String username, String password) {
		loggedInProfile = dbm.login(username, password);
		if (loggedInProfile != null) {
			currentProfile = loggedInProfile;
			return true;
		}
		return false;
	}
	
	public void logout() {
		loggedInProfile = null;
		currentProfile = new Profile(141, ProfileType.VISITOR);//TEMPORARY
	}
	
	/**
	 * Attempts to register a profile with the given credentials.
	 *
	 * @param username The username to register.
	 * @param password The password to register.
	 * @param p        The profile to register.
	 * @return <code>true</code>, if the operation was successful, <code>false</code> otherwise.
	 */
	public boolean register(String username, String password, RegisteredProfile p) {
		System.out.println("Placeholder registration");
		System.out.println("if (username.equals(\"" + username + "\")&&password.equals(\"" + password + "\")){\n" +
				"            return new RegisteredProfile(0x00000000, \"" + p.getName() + "\", \"" + p.getAddress() + "\", \"" + p.getPhone() + "\", \"" + p.getPhone() + "\", null);\n" +
				"        }");
		
		dbm.registerProfile(p, username, password);
		
		
		return true;
	}
	
	/**
	 * Test whether the username is taken.
	 *
	 * @param username The username to test.
	 * @return <code>true</code>, if the username is unavailable.
	 */
	public boolean usernameExists(String username) {
		return false;
	}
	
	/**
	 * Returns the {@link ProductCatalogue} instance, used for searching products.
	 *
	 * @return An instance of {@link ProductCatalogue}.
	 */
	public ProductCatalogue getProductCatalogue() {
		return productCatalogue;
	}
	
	public void addProduct(Product p) {
		if (currentProfile.getType() == ProfileType.ADMIN) {
			System.out.println("Placeholder product add");
			productCatalogue.addProduct(p);
			System.out.println("list.add(new product(\"" + p.getName() + "\",\"" + p.getCategory() + "\", " + p.getProductID() + ", " + p.getPrice() + "));\n");
		} else {
			System.out.println("Sorry, you are not logged in as an admin, and can not add new products.");
		}
	}
	
	/**
	 * Returns the currently logged in profile.
	 *
	 * @return A {@link RegisteredProfile} instance of the currently logged in profile. <code>null</code> if no user is logged in.
	 */
	@Deprecated
	public RegisteredProfile getLoggedInProfile() {
		return loggedInProfile;
	}
	
	/**
	 * Returns the currently logged in profile.
	 *
	 * @return A {@link Profile} instance of the currently logged in profile
	 */
	public Profile getCurrentProfile() {
		if (currentProfile == null) throw new IllegalStateException("Current profile is not allowed to be null!");
		return currentProfile;
	}

	public ArrayList<ExtraServices> showExtraServices() {
		return productCatalogue.getExtraServices(currentProfile.getCart().getProducts());
	}
}
