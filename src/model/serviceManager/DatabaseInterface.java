package model.serviceManager;

import java.sql.Connection;

/**
 * Created by Kentv on 30-05-2017.
 */
public interface DatabaseInterface {
	public Connection returnConnector();
	
	public boolean Open();
	
	public boolean Close();
}
