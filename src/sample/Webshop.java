package sample;


/**
 * Created by Alex on 08/05/2017.
 */
public class Webshop {
    private DatabaseManager dbm;

    private RegisteredProfile loggedInProfile;
    private Profile currentProfile;

    private ProductCatalogue productCatalogue;

    public Webshop() {
        currentProfile = new Profile(141,ProfileType.VISITOR);
        dbm = new DatabaseManager();
        productCatalogue = new ProductCatalogue(dbm.getProductList());
    }

    /**
     * Attempts to log in the user with the given credentials.
     * @param username The username to log in with.
     * @param password The password to log in with.
     * @return <code>true</code>, if a profile with the given credentials was found.
     */
    public boolean login(String username, String password){
        loggedInProfile = dbm.login(username, password);
        if (loggedInProfile!=null){
            currentProfile = loggedInProfile;
            return true;
        }
        return false;
    }

    public boolean logout()
    {
        loggedInProfile = null;

        if(loggedInProfile == null)
            return true;

        return false;
    }

    /**
     * Attempts to register a profile with the given credentials.
     * @param username The username to register.
     * @param password The password to register.
     * @param p The profile to register.
     * @return <code>true</code>, if the operation was successful, <code>false</code> otherwise.
     */
    public boolean register(String username, String password, RegisteredProfile p){
        System.out.println("Placeholder registration");
        System.out.println("if (username.equals(\""+username+"\")&&password.equals(\""+password+"\")){\n" +
                "            return new RegisteredProfile(0x00000000, \""+p.getName()+"\", \""+p.getAddress()+"\", \""+p.getPhone()+"\", \""+p.getPhone()+"\", null);\n" +
                "        }");
        return true;
    }

    /**
     * Test whether the username is taken.
     * @param username The username to test.
     * @return <code>true</code>, if the username is unavailable.
     */
    public boolean usernameExists(String username){
        return false;
    }

    /**
     * Returns the currently logged in profile.
     * @return A {@link RegisteredProfile} instance of the currently logged in profile. <code>null</code> if no user is logged in.
     */
    public RegisteredProfile getLoggedInProfile() {
        return loggedInProfile;
    }

    /**
     * Returns the {@link ProductCatalogue} instance, used for searching products.
     * @return An instance of {@link ProductCatalogue}.
     */
    public ProductCatalogue getProductCatalogue() {
        return productCatalogue;
    }

    public void addProduct(Product p){
        if (currentProfile.getType()==ProfileType.ADMIN){
            System.out.println("Placeholder product add");
            productCatalogue.addProduct(p);
            System.out.println("list.add(new Product(\""+p.getName()+"\",\""+p.getCategory()+"\", "+p.getProductID()+", "+p.getPrice()+"));\n");
        }else {
            System.out.println("Sorry, you are not logged in as an admin, and can not add new products.");
        }
    }

    public Profile getCurrentProfile() {
        return currentProfile;
    }
}
