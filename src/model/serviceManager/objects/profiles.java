package model.serviceManager.objects;

import model.profile.Profile;
import model.profile.RegisteredProfile;
import model.serviceManager.DatabaseInterface;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Created by Kentv on 30-05-2017.
 */
public class Profiles
{
    private static String sqlUserLogin = "SELECT * FROM profiles WHERE usernames ='[0]' AND passwords = crypt('[1]', profiles.salts);";

    private int identity;

    private String ProfilePrivileges;
    private String Name;
    private String Address;
    private String Phone;
    private String Email;

    public Profiles( String username, String password, DatabaseInterface db_interface )
    {
        if(!db_interface.Open())
            return;

        String sql = sqlUserLogin;

        sql = sql.replace("[0]", username);
        sql = sql.replace("[1]", password);

        retrieveTable(sql, db_interface );

        db_interface.Close();
    }

    //
    public void retrieveTable( String sql,
                               DatabaseInterface db_interface )
    {
        Connection c = db_interface.returnConnector();

        Statement stmt;
        ResultSet rs;

        try
        {
            stmt = c.createStatement();
            rs = stmt.executeQuery(sql);

            while ( rs.next() )
            {
                identity = rs.getInt("identities");

                Name = rs.getString("person_names");
                Phone = rs.getString("numbers");
                Email = rs.getString("emails");
                Address = rs.getString("address");
                ProfilePrivileges = rs.getString("account_types");

                System.out.println("Found User:" + Name);
            }

        }
        catch (Exception ex)
        {
            System.out.println(ex.getMessage());
        }

    }

    // Get
    public String getName()
    {
        return this.Name;
    }

    public String getProfilePrivileges()
    {
        return this.ProfilePrivileges;
    }

    public String getAddress()
    {
        return this.Address;
    }

    public String getEmail()
    {
        return this.Email;
    }

    public String getPhone()
    {
        return this.Phone;
    }

    public int getIdentity()
    {
        return this.identity;
    }

    // Set

    public static boolean RegisterProfile()
    {

        return false;
    }

    public static boolean UnregisterProfile()
    {
        return false;
    }

    public static boolean ExistProfile()
    {
        return false;
    }

    public static RegisteredProfile getModelProfile( Profiles prof )
    {
        RegisteredProfile resprof = new RegisteredProfile( prof.getIdentity(),
                                                            prof.getName(),
                                                            prof.getAddress(),
                                                            prof.getPhone(),
                                                            prof.getEmail());


        return resprof;
    }
}
