package model.serviceManager.blueprints;

import model.profile.RegisteredProfile;

import java.sql.Connection;

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

}
