package model.serviceManager.databases;

import model.product.Product;
import model.serviceManager.blueprints.AbstractDatabaseImplementation;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Kentv on 26-05-2017.
 */
public class postgresql extends AbstractDatabaseImplementation {
	private static String postgresqlConnectorheader = "postgresql";
	
	private String Username,
			Password;
	
	private String Url,
			Port,
			Database;
	
	@Override
	protected void initialiseConnectionString() {
		connectionString = connectorStringHeader + ":" +
				postgresqlConnectorheader + ":" +
				"[0]:[1]/[2]";
	}
	
	@Override
	protected void generateConnectionString() {
		initialiseConnectionString();
		connectionString = connectionString.replace("[0]", this.Url);
		connectionString = connectionString.replace("[1]", this.Port);
		connectionString = connectionString.replace("[2]", this.Database);
		
		System.out.print(connectionString + "\r\n");
	}
	
	// Required Constants for the Database Server
	protected void InitialiseDb(String Username, String Password) {
		this.Username = Username;
		this.Password = Password;
	}
	
	protected void InitialiseDb(String Username, String Password,
	                            String Url, String Port) {
		InitialiseDb(Username, Password);
		
		this.Url = Url;
		this.Port = Port;
	}
	
	protected void InitialiseDb(String Username, String Password,
	                            String Url, String Port,
	                            String Database) {
		InitialiseDb(Username, Password,
				Url, Port);
		
		this.Database = Database;
	}
	
	protected boolean Open() {
		try {
			connector = DriverManager.getConnection(connectionString,
					this.Username,
					this.Password);
			return true;
			
		} catch (Exception e) {
		
		}
		
		return false;
	}
	
	protected boolean Close() {
		try {
			connector.close();
			return true;
		} catch (Exception ex) {
		
		}
		return false;
	}
	
	// Is the necesarry requirements at place ? ie. do we have the required classes
	@Override
	protected boolean Requirements() {
		try {
			// Looks for postgresql
			Class.forName("org.postgresql.Driver");
			return true;
		} catch (Exception ex) {
		
		}
		return false;
	}
	
	// Commands
	@Override
	public String[] get_sql_ProductCategories() {
		Open();
		List<String> retList = null;
		Statement stmt = null;
		
		try {
			retList = new ArrayList<String>();
			
			stmt = connector.createStatement();
			ResultSet rs = stmt.executeQuery(Select_product_categories);
			
			while (rs.next()) {
				String s = rs.getString("categories");
				retList.add(s);
			}
			
			String[] returning = new String[retList.size()];
			returning = retList.toArray(returning);
			
			Close();
			
			return returning;
		} catch (Exception ex) {
		
		}
		
		Close();
		
		return null;
	}
	
	@Override
	public ArrayList<Product> get_sql_Products() {
		ArrayList<Product> retList = null;
		Statement stmt = null;
		
		Open();
		try {
			stmt = connector.createStatement();
			ResultSet rs = stmt.executeQuery(Select_products);
			
			retList = new ArrayList<Product>();
			
			while (rs.next()) {
				int productId = rs.getInt("identities");
				String product_name = rs.getString("product_names");
				double productPrice = rs.getDouble("price");
				String CategoryName = rs.getString("name");
				
				Product p = new Product(product_name,
						CategoryName,
						productId,
						productPrice);
				
				retList.add(p);
			}
			
			Close();
			
			return retList;
		} catch (Exception ex) {
			System.out.printf(ex.getMessage());
			
		}
		
		Close();
		
		return null;
	}
	
	
	public int get_identity_sql_productCategory(String str) {
		Open();
		
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			stmt = connector.createStatement();
			
			//Hack: fixing a bug, in the code
			String upperCaseFan = str.substring(0, 1).toUpperCase() + str.substring(1);
			
			String sql = Select_product_categories_identity.replace("[0]", upperCaseFan);
			rs = stmt.executeQuery(sql);
			
			System.out.print(sql + "\r\n");
			
			int identity = -1;
			
			while (rs.next()) {
				identity = rs.getInt("identities");
			}
			
			Close();
			return identity;
		} catch (Exception ex) {
			System.out.print(ex.getMessage());
			
		}
		
		Close();
		
		return -1;
	}
	
	public boolean insert_sql_product(String name, double price, String Category) {
		Statement stmt = null;
		
		try {
			int categoryIdentity = get_identity_sql_productCategory(Category);
			
			System.out.print("category: " + Integer.toString(categoryIdentity) + "\r\n");
			
			if (categoryIdentity == -1)
				return false;
			
			Open();
			stmt = connector.createStatement();
			
			String sql = Insert_product.replace("[0]", name);
			sql = sql.replace("[1]", Double.toString(price));
			sql = sql.replace("[2]", Integer.toString(categoryIdentity));
			
			System.out.print(sql + "\r\n");
			
			stmt.execute(sql);
			
			Close();
			return true;
		} catch (Exception ex) {
			System.out.print(ex.getMessage());
		}
		
		Close();
		
		return false;
	}
	
	private static String Select_product_categories_identity = "SELECT * FROM product_categories WHERE categories='[0]';";
	private static String Select_product_categories = "SELECT categories FROM product_categories;";
	private static String Select_products = "SELECT * FROM products;";
	
	private static String Insert_product = "INSERT INTO catalog.product(name, price, category) VALUES('[0]', [1], [2])";
}
