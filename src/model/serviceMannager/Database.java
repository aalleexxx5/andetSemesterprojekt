package model.serviceMannager;

import model.profile.RegisteredProfile;

/**
 * Created by madsen on 5/10/17.
 */
public abstract class Database {
	public abstract boolean InsertProfile(int ID,
	                                      String Name,
	                                      String Username,
	                                      String Password,
	                                      String Address,
	                                      String Phone,
	                                      String Email,
	                                      ProfileType type);
	
	public abstract boolean InsertProfile(RegisteredProfile rp);
	
	public abstract RegisteredProfile SelectProfile(int Identity);
	
	public abstract RegisteredProfile[] SearchProfiles(String Token);
	
	public abstract boolean ExistProfile();
	
	public abstract RegisteredProfile[] SelectUsers();
	
}
