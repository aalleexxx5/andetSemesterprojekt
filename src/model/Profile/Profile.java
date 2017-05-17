package Model.Profile;

import Model.Product.Product;
import Model.Product.ProductList;
import Model.Database.ProfileType;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 */
public class Profile {
	//Session storage of a profile. For a returning visitor to keep his/her cart+wish list stored
	private ProductList cart;
	private ArrayList<Product> wishlist;
	private ProfileType type;
	private int profileID; // One could imagine this ID is stored client side while client is a visitor. To allow revisits.
	
	public Profile(int profileID, ProfileType type) {
		this.type = type;
		this.profileID = profileID;
		cart = new ProductList();
		wishlist = new ArrayList<Product>();
	}
	
	public void setType(ProfileType type) {
		this.type = type;
	}
	
	/**
	 * Returns the cart from the profile
	 *
	 * @return A {@link ProductList} containing what the user has added.
	 */
	public ProductList getCart() {
		return cart;
	}
	
	/**
	 * Returns the wish list from the profile.
	 *
	 * @return An ArrayList containing the products the user has added.
	 */
	public ArrayList<Product> getWishlist() {
		return wishlist;
	}
	
	/**
	 * Returns the profiletype associated with this profile
	 *
	 * @return The {@link ProfileType} associated with this profile.
	 */
	public ProfileType getType() {
		return type;
	}
	
	/**
	 * Returns the unique id associated with this profile.
	 *
	 * @return An integer representing the profile id.
	 */
	public int getProfileID() {
		return profileID;
	}
}
