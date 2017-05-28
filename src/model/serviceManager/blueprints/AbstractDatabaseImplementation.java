package model.serviceManager.blueprints;

import model.product.Product;
import model.profile.RegisteredProfile;

import java.sql.Connection;
import java.util.ArrayList;

/**
 * Created by madsen on 5/10/17.
 */
public abstract class AbstractDatabaseImplementation
{
	protected static String connectorStringHeader = "jdbc";
	
	protected String connectionString = "";
	
	protected Connection connector = null;

	protected abstract void initialiseConnectionString();
	protected abstract void generateConnectionString();

	// Looks for basic Requirements inorder to run
	protected abstract boolean Requirements();

	public abstract String[] get_sql_ProductCategories();
	public abstract ArrayList<Product> get_sql_Products();
}
