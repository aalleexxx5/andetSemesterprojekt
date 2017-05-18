package model.profile;

import model.serviceMannager.ProfileType;

/**
 * Created by Alex on 08/05/2017.
 */
public class RegisteredProfile extends Profile {
	private String name;
	private String address;
	private String phone;
	private String email;
	private String password;
	private String username;
	private Order[] processedOrders;
	
	/**
	 * Used for visitors who has logged in.
	 */
	public RegisteredProfile(int profileID, String name, String address, String phone, String email) {
		super(profileID, ProfileType.CLIENT);
		
		this.name = name;
		this.address = address;
		this.phone = phone;
		this.email = email;
		
		this.processedOrders = null;
	}
	
	public RegisteredProfile(int profileID, String name, String password, String address, String phone, String email) {
		this(profileID, name, address, phone, email);
		
		this.password = password;
	}
	
	public RegisteredProfile(int profileID, String name, String username, String password, String address, String phone, String email) {
		this(profileID, name, password, address, phone, email);
		
		this.username = username;
	}
	
	public RegisteredProfile(int profileID, String name, String address, String phone, String email, Order[] processedOrders) {
		this(profileID, name, address, phone, email);
		
		this.processedOrders = processedOrders;
	}
	
	public RegisteredProfile(int profileID, String name, String address, String phone, String email, Order[] processedOrders, ProfileType type) {
		this(profileID, name, address, phone, email, processedOrders);
		
		this.setType(type);
	}
	
	public RegisteredProfile(int profileID, String name, String username, String password, String address, String phone, String email, Order[] processedOrders, ProfileType type) {
		this(profileID, name, address, phone, email, processedOrders);
		
		setUsername(username);
		setPassword(password);
		
		this.setType(type);
	}
	
	/**
	 * Returns the name of whoever owns the profile
	 *
	 * @return the name of the user.
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * Returns the address of the owner of the profile.
	 *
	 * @return The address of the user.
	 */
	public String getAddress() {
		return address;
	}
	
	/**
	 * Returns the phone number of the owner of the profile.
	 *
	 * @return A phone number.
	 */
	public String getPhone() {
		return phone; // TODO: VERIFY: No formatting of the number.
	}
	
	/**
	 * Returns the email address of the owner of the profile.
	 *
	 * @return An email address.
	 */
	public String getEmail() {
		return email;
	}
	
	/**
	 * Returns all processed orders from this profile or null if none has been processed.
	 *
	 * @return An array of orders. Or null if none has been processed.
	 */
	public Order[] getProcessedOrders() {
		return processedOrders;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String pass) {
		this.password = pass;
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String user) {
		this.username = user;
	}
	
	public String toString() {
		return getUsername() + ", " + getPassword() + ", " + getName() + "\r\n";
	}
	
}
