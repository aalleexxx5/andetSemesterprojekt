package model.profile;

import model.product.Product;
import model.product.Cart;

import java.util.ArrayList;

/**
 * Created by Alex on 08/05/2017.
 */
public class Profile {
	//Session storage of a profile. For a returning visitor to keep his/her cart+wish list stored
	private Cart cart;
	private ArrayList<Product> wishlist;
	private ProfileType type;
	private int profileID; // One could imagine this ID is stored client side while client is a visitor. To allow revisits.
	
	public Profile(int profileID, ProfileType type) {
		this.type = type;
		this.profileID = profileID;
		cart = new Cart();
		wishlist = new ArrayList<Product>();
	}
	
	/**
	 * Returns the cart from the profile
	 *
	 * @return A {@link Cart} containing what the user has added.
	 */
	public Cart getCart() {
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
	
	public void setType(ProfileType type) {
		this.type = type;
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
