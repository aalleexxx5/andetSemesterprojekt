package model.serviceMannager;

import model.Profile.RegisteredProfile;

import java.io.*;
import java.io.File;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by madsen on 5/10/17.
 */
public class File_database extends Database {
	// Class Variables
	// Tag: Statics
	private static String Extension = ".ser";
	private static String Generic_filename = "profile_";
	// Tag: Paths
	private String directoryDatabase = "./database/";
	// Tag: Debug
	private boolean debugMode = true;
	
	// Constructor
	public File_database() {
		Initialise();
	}
	
	// Init
	public void Initialise() {
		Prepare();
		
	}
	
	private void Prepare() {
		// Prepares, what is necesarry to start
		File db = new File(directoryDatabase);
		
		if (db.exists() != true) {
			// Recursive function, in case the user makes a long path, where several directories don't exist
			db.mkdirs();
		}
		
		// Additional stuff.
		// Generating data, etc.
		debug_gen(db);
	}
	
	// In debug mode, Generates data
	private void debug_gen(File db) {
		if (debugMode) {
			if (db.listFiles().length == 0 ||
					db.listFiles() == null)
				Generate_Data();
		}
		
	}
	
	private void Generate_Data() {
		SerializeProfile(new RegisteredProfile(0xDEAD_BEEF,
				"dead beef",
				"deadbeef",
				"deadbeef",
				"Local butchery, butcheryway 666 Butchery City",
				"37359285",
				"dead@beef.com"));
		
		SerializeProfile(new RegisteredProfile(0xDEAD_BEF0,
				"Admin",
				"admin",
				"admin",
				"Wherever Admin lives",
				"12121212",
				"admin@admin.com",
				null,
				ProfileType.ADMIN));
		
		SerializeProfile(new RegisteredProfile(0xDEAF_FACE,
				"deaf face",
				"deaf face",
				"deaf face",
				"SilentStreet 15, Silent Hill",
				"37360749",
				"deaf@face.org"));
	}
	
	private boolean ExistUserProfile(RegisteredProfile current_rp) {
		RegisteredProfile[] list = getProfiles();
		
		if (list == null)
			return false;
		
		for (RegisteredProfile rp : list) {
			if (rp.equals(current_rp)) {
				return true;
			}
		}
		
		return false;
	}
	
	private RegisteredProfile convertFrom(Profile_file object) {
		RegisteredProfile rp = null;
		
		rp = new RegisteredProfile(object.Identity,
				object.name,
				object.username,
				object.password,
				object.address,
				object.phone,
				object.email,
				null,
				object.type);
		
		return rp;
	}
	
	private Profile_file convertTo(RegisteredProfile rp) {
		System.out.print("Converts File to PF\r\n");
		Profile_file pf = null;
		
		pf = new Profile_file();
		
		if (pf == null)
			return null;
		
		pf.Identity = rp.getProfileID();
		pf.username = rp.getUsername();
		pf.password = rp.getPassword();
		pf.name = rp.getName();
		pf.address = rp.getAddress();
		pf.email = rp.getEmail();
		pf.phone = rp.getPhone();
		
		System.out.print("returns object\r\n");
		return pf;
	}
	
	private RegisteredProfile[] getProfiles() {
		List<RegisteredProfile> rplist = getProfile_list();
		
		if (rplist.isEmpty())
			return null;
		
		System.out.print("List isn't empty");
		
		try {
			RegisteredProfile[] array = rplist.toArray(new RegisteredProfile[rplist.size()]);
			return array;
		} catch (Exception ex) {
			System.out.print("Array Error");
			
		}
		
		return null;
	}
	
	private List<RegisteredProfile> getProfile_list() {
		List<RegisteredProfile> retList = new LinkedList<RegisteredProfile>();
		
		File f = new File(directoryDatabase);
		
		for (File current : f.listFiles()) {
			if (current.isFile()) {
				RegisteredProfile rp = DeserializeProfile(current.getAbsolutePath());
				
				if (rp == null)
					continue;
				
				retList.add(rp);
			}
		}
		
		return retList;
	}
	
	private boolean SerializeProfile(RegisteredProfile rp) {
		if (ExistUserProfile(rp))
			return false;
		
		int files_counter = 1 + getAmountOfFiles(directoryDatabase);
		
		Profile_file pf = convertTo(rp);
		
		if (pf == null)
			return false;
		
		try {
			String final_destination = directoryDatabase + Generic_filename + Integer.toString(files_counter) + Extension;
			
			FileOutputStream fos = new FileOutputStream(final_destination);
			ObjectOutputStream outObj = new ObjectOutputStream(fos);
			
			outObj.writeObject(pf);
			outObj.close();
			
			fos.close();
			
			return true;
		} catch (Exception ex) {
			System.out.print("Error Serialize Profiles");
		}
		
		return false;
		
	}
	
	private RegisteredProfile DeserializeProfile(String name) {
		System.out.print("Deserialize : " + name + "\r\n");
		
		RegisteredProfile rg = null;
		Profile_file pf = null;
		
		try {
			FileInputStream fileInput = new FileInputStream(name);
			ObjectInputStream OIS = new ObjectInputStream(fileInput);
			
			// Retrieves object
			pf = (Profile_file) OIS.readObject();
			
			OIS.close();
			fileInput.close();
		} catch (IOException ex) {
			System.out.print("error : " + ex.getMessage() + " \r\n");
			return null;
		} catch (ClassNotFoundException cnfe) {
			System.out.print("error : " + cnfe.getMessage() + " \r\n");
			return null;
		}
		
		rg = convertFrom(pf);
		System.out.print(rg.toString());
		
		return rg;
	}
	
	private int getAmountOfFiles(String db) {
		File file = new File(db);
		
		int counter = 0;
		
		for (File f : file.listFiles()) {
			if (f.isFile())
				counter++;
		}
		
		return counter;
	}
	
	// Overrides
	@Override
	public boolean InsertProfile(RegisteredProfile rp) {
		SerializeProfile(rp);
		
		return false;
	}
	
	@Override
	public boolean InsertProfile(int ID,
	                             String Name,
	                             String Username,
	                             String Password,
	                             String Address,
	                             String Phone,
	                             String Email,
	                             ProfileType type) {
		return InsertProfile(
				new RegisteredProfile(ID,
						Name,
						Username,
						Password,
						Address,
						Phone,
						Email,
						null, type));
		
	}
	
	@Override
	public boolean ExistProfile() {
		
		return false;
	}
	
	@Override
	public RegisteredProfile[] SelectUsers() {
		return getProfiles();
	}
	
	@Override
	public RegisteredProfile SelectProfile(int identity) {
		return null;
	}
	
	@Override
	public RegisteredProfile[] SearchProfiles(String s) {
		return null;
	}
}
