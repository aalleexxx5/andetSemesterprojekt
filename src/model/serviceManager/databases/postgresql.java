package model.serviceManager.databases;

import model.serviceManager.blueprints.AbstractDatabaseImplementation;
import sx.blah.discord.handle.impl.obj.User;

import java.sql.DriverManager;

/**
 * Created by Kentv on 26-05-2017.
 */
public class postgresql extends AbstractDatabaseImplementation
{
	private static String postgresqlConnectorheader = "postgresql";

	private String Username,
				   Password;

	private String Url,
				   Port,
				   Database;
	
	@Override
	protected void initialiseConnectionString()
	{
		connectionString = connectorStringHeader + ":" +
				           postgresqlConnectorheader + ":" +
						   "[0]:[1]/[2]";
	}

	@Override
	protected void generateConnectionString()
	{
		initialiseConnectionString();
		connectionString = connectionString.replace("[0]", this.Url );
		connectionString = connectionString.replace("[1]", this.Port );
		connectionString = connectionString.replace("[2]", this.Database );

		System.out.print(connectionString);
	}

	// Required Constants for the Database Server
	protected void InitialiseDb( String Username, String Password )
	{
		this.Username = Username;
		this.Password = Password;
	}

	protected void InitialiseDb( String Username, String Password,
								 String Url, String Port )
	{
		InitialiseDb( Username, Password );

		this.Url = Url;
		this.Port = Port;
	}

	protected void InitialiseDb( String Username, String Password,
								 String Url, String Port,
								 String Database )
	{
		InitialiseDb( Username, Password,
					  Url, Port );

		this.Database = Database;
	}

	protected boolean Open()
	{
		try
		{
			connector = DriverManager.getConnection( connectionString,
													 this.Username,
													 this.Password );
			return true;

		}
		catch (Exception e)
		{

		}

		return false;
	}

	protected boolean Close()
	{
		try
		{
			connector.close();
			return true;
		}
		catch (Exception ex)
		{

		}
		return false;
	}

	// Is the necesarry requirements at place ? ie. does we have the required classes
	@Override
	protected boolean Requirements()
	{
		try
		{
			Class.forName("org.postgresql.Driver");
			return true;
		}
		catch (Exception ex)
		{

		}
		return false;
	}


}
