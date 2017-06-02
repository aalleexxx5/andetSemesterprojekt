package model.serviceManager.objects;

import model.profile.Profile;
import model.profile.ProfileType;
import model.profile.RegisteredProfile;
import model.serviceManager.DatabaseInterface;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Created by Kentv on 30-05-2017.
 */
public class Profiles {
	static String insertSqlprofile_header = "INSERT INTO account.profile_header(username, password) VALUES('[0]', '[1]')";
	static String insertSQLProfile_Information = "INSERT INTO account.profile_information(ref_user, email) VALUES([0], '[1]')";
	static String getSQLuserProfilenames = "SELECT * from profile_names WHERE usernames='[0]';";
	private static String sqlUserLogin = "SELECT * FROM profiles WHERE usernames='[0]' AND passwords = crypt('[1]', profiles.salts);";
	private int identity = -1;
	private String ProfilePrivileges = "Unknown";
	private String Name = "";
	private String Address = "";
	private String Phone = "";
	private String Email = "";
	
	public Profiles(String username, String password, DatabaseInterface db_interface) {
		if (!db_interface.Open())
			return;
		
		String sql = sqlUserLogin;
		
		sql = sql.replace("[0]", username);
		sql = sql.replace("[1]", password);
		
		retrieveTable(sql, db_interface);
		
		db_interface.Close();
	}
	
	// Set
	public static boolean RegisterProfile(String username, String password,
	                                      RegisteredProfile rp,
	                                      DatabaseInterface di) {
		if (ExistProfile(username, di))
			return false;
		
		int profheader = -1;
		
		profheader = create_profheader(username, password, di);
		
		if (profheader == -1)
			return false;
		
		if (create_profinfo(profheader, rp, di) == -1)
			return false;
		
		return true;
	}
	
	private static int create_profheader(String username, String password,
	                                     DatabaseInterface di) {
		// Register User_prof_header
		String sql = insertSqlprofile_header;
		
		sql = sql.replace("[0]", username);
		sql = sql.replace("[1]", password);
		
		int ret = -1;
		// Upload
		
		try {
			di.Open();
			
			Connection c = di.returnConnector();
			
			Statement stmt = null;
			
			stmt = c.createStatement();
			stmt.executeUpdate(sql, Statement.RETURN_GENERATED_KEYS);
			
			ResultSet rs = stmt.getGeneratedKeys();
			
			while (rs.next()) {
				ret = rs.getInt("identities");
			}
		} catch (Exception ex) {
			
		} finally {
			di.Close();
		}
		
		return ret;
	}
	
	private static int create_profinfo(int user, RegisteredProfile prof, DatabaseInterface di) {
		String sql = insertSQLProfile_Information;
		
		sql = sql.replace("[0]", Integer.toString(user));
		sql = sql.replace("[1]", prof.getEmail());
		
		System.out.print(sql);
		
		try {
			di.Open();
			
			Connection c = di.returnConnector();
			
			Statement stmt = c.createStatement();
			
			stmt.execute(sql);
		} catch (Exception ex) {
			System.out.print(ex.getMessage());
		} finally {
			di.Close();
		}
		
		return -1;
	}
	
	public static boolean UnregisterProfile() {
		throw new NotImplementedException();
	}
	
	public static boolean ExistProfile(String username, DatabaseInterface di) {
		String sql = getSQLuserProfilenames.replace("[0]", username);
		
		boolean ret = false;
		
		try {
			di.Open();
			
			Connection c = di.returnConnector();
			
			Statement stmt;
			ResultSet rs;
			
			stmt = c.createStatement();
			rs = stmt.executeQuery(sql);
			
			while (rs.next()) {
				if (username.equals(rs.getString("usernames"))) {
					ret = true;
				}
			}
		} catch (Exception ex) {
			
		} finally {
			di.Close();
		}
		
		return ret;
	}
	
	public static RegisteredProfile getModelProfile(Profiles prof) {
		RegisteredProfile resprof = new RegisteredProfile(prof.getIdentity(),
				prof.getName(),
				prof.getAddress(),
				prof.getPhone(),
				prof.getEmail());
		
		return setPrivileges(prof.getProfilePrivileges(), resprof);
	}
	
	public static RegisteredProfile setPrivileges(String privileges, RegisteredProfile prof) {
		RegisteredProfile rp = prof;
		
		switch (privileges) {
			case "employee":
				rp.setType(ProfileType.EMPLOEE);
				break;
			
			case "admin":
				rp.setType(ProfileType.ADMIN);
				break;
			
			case "client":
				rp.setType(ProfileType.CLIENT);
				break;
			
			default:
				rp.setType(ProfileType.VISITOR);
				break;
		}
		
		return prof;
	}
	
	//
	public void retrieveTable(String sql,
	                          DatabaseInterface db_interface) {
		Connection c = db_interface.returnConnector();
		
		Statement stmt;
		ResultSet rs;
		
		try {
			stmt = c.createStatement();
			rs = stmt.executeQuery(sql);
			
			while (rs.next()) {
				identity = rs.getInt("identities");
				
				Name = rs.getString("person_names");
				Phone = rs.getString("numbers");
				Email = rs.getString("emails");
				Address = rs.getString("address");
				ProfilePrivileges = rs.getString("account_types");
				
				System.out.println("Found User:" + Name);
			}
		} catch (Exception ex) {
			System.out.print("Error");
			System.out.println(ex.getMessage());
		}
	}
	
	// Get
	public String getName() {
		return this.Name;
	}
	
	public String getProfilePrivileges() {
		return this.ProfilePrivileges;
	}
	
	public String getAddress() {
		return this.Address;
	}
	
	public String getEmail() {
		return this.Email;
	}
	
	public String getPhone() {
		return this.Phone;
	}
	
	public int getIdentity() {
		return this.identity;
	}
}
