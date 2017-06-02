package model.profile;

/**
 * Created by Alex on 08/05/2017.
 */
public class RegisteredProfile extends Profile {
	private String name;
	private String address;
	private String phone;
	private String email;
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
		
		this.processedOrders = new Order[0];
	}
	
	public RegisteredProfile(int profileID, String name, String address, String phone, String email, Order[] processedOrders) {
		this(profileID, name, address, phone, email);
		
		this.processedOrders = processedOrders;
	}
	
	public RegisteredProfile(int profileID, String name, String address, String phone, String email, Order[] processedOrders, ProfileType type) {
		this(profileID, name, address, phone, email, processedOrders);
		
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
}
