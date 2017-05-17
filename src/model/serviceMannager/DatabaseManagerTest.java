package model.serviceMannager;

import model.Product.Product;
import model.Profile.RegisteredProfile;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;

import static org.junit.Assert.*;

/**
 * Testing for the DatabaseManager.
 * Created by Alex on 14/05/2017.
 */
public class DatabaseManagerTest {
	static final DatabaseManager dbm = new DatabaseManager();
	static final String uname = "uname";
	static final String uname2 = "uname2";
	static final String uname3 = "uname3";
	static final String pword = "pword";
	static final String pword2 = "pword2";
	static final String pword3 = "pword3";
	static final RegisteredProfile profile = new RegisteredProfile(0, "name", "address", "11111111", "aa@aa.aa");
	static final RegisteredProfile profile2 = new RegisteredProfile(1, "name2", "address2", "22222222", "bb@bb.bb");
	static final Product product = new Product("aa", "electronics", -1, 0.00);
	static final Product product2 = new Product("bb", "electronics", -2, 0.00);
	static final Product product3 = new Product("cc", "cc", -3, 0.00);
	
	@Before
	public void setUpDatabase() {
		dbm.registerProfile(profile, uname, pword);
		dbm.unregisterProfile(profile2);
		dbm.addProduct(product);
		dbm.removeProduct(product2);
	}
	
	@AfterClass
	public static void cleanupDatabase() {
		dbm.unregisterProfile(profile);
		dbm.unregisterProfile(profile2);

	}
	
	@org.junit.Test
	public void userExists() throws Exception {
		//A registered username should return true
		assertTrue(dbm.userExists(uname));
		//An unregistered username should return false
		assertFalse(dbm.userExists(uname2));
	}
	
	@org.junit.Test
	public void registerProfile() throws Exception {
		//registering an already-registered profile should return false
		dbm.registerProfile(profile, uname, pword);
		//registering a different profile with the same username, should return false
		dbm.registerProfile(profile2, uname, pword);
		//registering a new profile should return true
		dbm.registerProfile(profile2, uname2, pword2);
		//registering an already registered profile, with a different username should return false
		dbm.registerProfile(profile, uname3, pword);
	}
	
	@org.junit.Test
	public void login() throws Exception {
		//Logging in an unknown profile should result in a null object returned
		assertNull(dbm.login(uname3, pword3));
		//Logging in with an incorrect password, should return null
		assertNull(dbm.login(uname, pword2));
		//Logging in with an incorrect username, should return null
		assertNull(dbm.login(uname2, pword));
		//Logging in with a correct username and password, should return a profile with the same information as the saved one though not necessarily the same object.
		assertTrue(profile.getName().equals(dbm.login(uname, pword).getName()));
		assertTrue(profile.getAddress().equals(dbm.login(uname, pword).getAddress()));
		assertTrue(profile.getPhone().equals(dbm.login(uname, pword).getPhone()));
		assertTrue(profile.getEmail().equals(dbm.login(uname, pword).getEmail()));
		
		//Different instances of the DatabaseManager should share the same data set. As the object represents a connection to a database, and not a database in itself
		DatabaseManager dbm2 = new DatabaseManager();
		assertTrue(profile.getName().equals(dbm2.login(uname, pword).getName()));
		assertTrue(profile.getAddress().equals(dbm2.login(uname, pword).getAddress()));
		assertTrue(profile.getPhone().equals(dbm2.login(uname, pword).getPhone()));
		assertTrue(profile.getEmail().equals(dbm2.login(uname, pword).getEmail()));
	}
	
	@org.junit.Test(timeout = 500)
	public void getProductList() throws Exception {
		//The returned products from the database should not be null.
		assertNotNull(dbm.getProductList());
	}

	@org.junit.Test
	public void addProduct() throws Exception {
		// a product should be registered
		assertTrue(dbm.addProduct(product2));
		//an already registered product should not be able to register.
		assertFalse(dbm.addProduct(product));
		// a product with an invalid category should not be registered.
		assertFalse(dbm.addProduct(product3));
	}

	@org.junit.Test
	public void removeProduct() throws Exception {
		//a registered product should be removed
		assertTrue(dbm.removeProduct(product));
		//removing a non registered product should return false
		assertFalse(dbm.removeProduct(product));
	}



	@org.junit.Test(timeout = 500)
	public void getProductCategoriesShouldNotReturnNull() throws Exception {
		assertNotNull(dbm.getProductCategories());
	}
}