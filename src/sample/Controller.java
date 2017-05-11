package sample;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.transformation.SortedList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundFill;
import javafx.scene.paint.Paint;

import java.net.URL;
import java.util.ResourceBundle;

public class Controller implements Initializable{

    //TODO search with string.contains
    private static String lightPink = "ffcccc";
    private static String pink = "ffaaaa";
    private static String white = "ffffff";

    public Label topLabel;
    public PasswordField password;
    public TextField username;
    public Label loggedInLabel;

    public Button login;
    public Button logout;

    public Button signUp;
    public PasswordField signPassword;
    public PasswordField signRepPassword;
    public TextField signUsername;
    public TextField signEmail;
    public TextField signName;
    public TextField signPhone;
    public TextArea signAddress;

    public TableView<Product> shopTable;
    public TableColumn shopListNameCol;
    public TableColumn shopListPriceCol;
    public TableColumn shopListCategoryCol;

    public TextField addProductName;
    public TextField addProductCategory;
    public TextField addProductID;
    public Button addProductSubmit;
    public TextField addProductPrice;

    private Webshop webshop;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        webshop = new Webshop();
        ObservableList<Product> productList = FXCollections.observableArrayList(webshop.getProductCatalogue().getProducts());
        shopListNameCol.setCellValueFactory(new PropertyValueFactory<>("name"));
        shopListPriceCol.setCellValueFactory(new PropertyValueFactory<>("price"));
        shopListCategoryCol.setCellValueFactory(new PropertyValueFactory<>("category"));
        shopTable.setItems(productList);
    }

    /**
     * Verifies the email address from a regular expression.
     * A valid email address has more than 0 non-whitespace characters, followed by an @-sign, followed by more than 0 non-whitespace characters,
     * followed by a dot, followed by more than 0 non-whitespace characters.
     * The function runs on a key typed event in the email field, and turns the field a pale green, email is valid.
     * @param e The key event triggering the function.
     */
    @FXML
    void emailVerification(KeyEvent e){
        if (signEmail.getText().matches("(\\w+)@(\\w+)\\.(\\w+)")){
            signEmail.setBackground(new Background(new BackgroundFill(Paint.valueOf("ccffcc"),null,null)));
        }
    }

    /**
     * Verifies all textfields concerned with the sign up process. An invalid field will be made red, to alert the user of an error.
     * TODO There is currently no error message displayed.
     * A valid user has:
     * A password longer than 8 characters.
     * A Repeat password matching the password field.
     * A unique username
     * A valid email, using the same validation as emailVerification
     * A phone number consisting of exactly 8 digits.
     * A non-empty name and address field.
     * If all fields are valid, the profile will be created. Whether the creation was successful is currently be printed through sout.
     * @param e The event triggering the function.
     */
    @FXML
    void signUp(ActionEvent e){
        boolean isProfileValid = true;
        if (signPassword.getText().length() < 8) {
            signPassword.setBackground(new Background(new BackgroundFill(Paint.valueOf(lightPink),null,null)));
            isProfileValid = false;
        }
            if (signPassword.getText().equals(signRepPassword.getText())) {
                signRepPassword.setBackground(new Background(new BackgroundFill(Paint.valueOf(white),null,null)));
                signPassword.setBackground(new Background(new BackgroundFill(Paint.valueOf(white),null,null)));
            }else {
                signRepPassword.setBackground(new Background(new BackgroundFill(Paint.valueOf(lightPink),null,null)));
                isProfileValid = false;
            }

        if (signUsername.getText().isEmpty()||webshop.usernameExists(username.getText())){
            signUsername.setBackground(new Background(new BackgroundFill(Paint.valueOf(lightPink),null,null)));
            isProfileValid = false;
        }

        if (!signEmail.getText().matches("(\\w+)@(\\w+)\\.(\\w+)")){
            signEmail.setBackground(new Background(new BackgroundFill(Paint.valueOf(lightPink),null,null)));
            isProfileValid = false;
        }

        if (signName.getText().isEmpty()){
            signName.setBackground(new Background(new BackgroundFill(Paint.valueOf(lightPink),null,null)));
            isProfileValid = false;
        }

        if (!signPhone.getText().matches("\\d{8}")){
            signPhone.setBackground(new Background(new BackgroundFill(Paint.valueOf(lightPink),null,null)));
            isProfileValid = false;
        }

        if (signAddress.getText().isEmpty()){
            signAddress.setBackground(new Background(new BackgroundFill(Paint.valueOf(pink),null,null)));
            isProfileValid = false;
        }
        if ( isProfileValid )
        {
             System.out.println(
                     webshop.register(
                             signUsername.getText(),
                             signPassword.getText(),
                             new RegisteredProfile(0,
                                     signName.getText(),
                                     signUsername.getText(),
                                     signPassword.getText(),
                                     signAddress.getText(),
                                     signPhone.getText(),
                                     signEmail.getText() )
                     )
             );
        }
    }

    /**
     * Attempts to find and log in the user from the credentials inserted in the username and password field.
     * The label notifies the user if the login was successful.
     * @param e The event triggering the function.
     */
    @FXML
    void login(ActionEvent e){
        if (webshop.login(username.getText(),password.getText())){
            topLabel.setText("Successfully logged in as "+ webshop.getLoggedInProfile().getName());
        }
        else topLabel.setText("User/Password combination does not exist.");

        if (webshop.getLoggedInProfile()==null){
            loggedInLabel.setText("Logged in as: Visitor");
        }else{
            loggedInLabel.setText("Logged in as: "+webshop.getCurrentProfile().getType());
        }
    }

    @FXML
    void logout(ActionEvent ae)
    {
        Boolean loggedout = webshop.logout();

        if(loggedout)
            topLabel.setText("Successfully logout");
    }

    @FXML
    public void addProduct(ActionEvent event) {
        if (addProductID.getText().matches("\\d*")){
            if (addProductPrice.getText().matches("(\\d+)[.,](\\d{1,2})")){
                webshop.addProduct(new Product(addProductName.getText(),addProductCategory.getText(),Integer.valueOf(addProductID.getText()),Double.valueOf(addProductPrice.getText())));
            }else{
                System.out.println("Product Price is not formatted correctly.");
            }
        }else{
            System.out.println("Product ID is not formatted correctly");
        }
    }
}
