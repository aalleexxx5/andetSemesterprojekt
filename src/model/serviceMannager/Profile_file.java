package model.serviceMannager;

import java.io.Serializable;

/**
 * Created by madsen on 5/11/17.
 */
public class Profile_file implements Serializable {
	public int Identity;
	public ProfileType type;
	public String name;
	public String address;
	public String phone;
	public String email;
	public String password;
	public String username;
}
