package Model.Database;

import Model.Profile.RegisteredProfile;

/**
 * Created by Kentv on 17-05-2017.
 */
public class PostgresDatabase extends Database
{
    public PostgresDatabase()
    {

    }

    @Override
    public boolean ExistProfile()
    {
        return false;
    }

    @Override
    public boolean InsertProfile(RegisteredProfile rp)
    {
        return false;
    }

    @Override
    public boolean InsertProfile( int ID,
                                  String Name,
                                  String Username,
                                  String Password,
                                  String Address,
                                  String Phone,
                                  String Email,
                                  ProfileType type )
    {
        return false;
    }

    @Override
    public RegisteredProfile SelectProfile( int Identity )
    {

        return null;
    }

    @Override
    public RegisteredProfile[] SearchProfiles( String Token )
    {
        return new RegisteredProfile[0];
    }

    @Override
    public RegisteredProfile[] SelectUsers()
    {
        return new RegisteredProfile[0];
    }

    // Straight
    @Override
    public void Execute()
    {

    }

    // Multiple Queries
    @Override
    public void SlowExecute()
    {

    }
}
