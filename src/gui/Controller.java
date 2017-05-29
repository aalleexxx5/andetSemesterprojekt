package gui;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundFill;
import javafx.scene.paint.Paint;
import model.product.Product;
import model.profile.RegisteredProfile;
import controller.Webshop;

import java.net.URL;
import java.util.ResourceBundle;

public class Controller implements Initializable {
	//TODO search with string.contains
	private static String INVALID_TEXT_FIELD_COLOR = "ffcccc";
	private static String DEFAULT_TEXT_FIELD_COLOR = "ffffff";
	private static String APPROVED_TEXT_FIELD_COLOR = "ccffcc";
	
	public Label topLabel;
	public Label loggedInLabel;
	
	public PasswordField password;
	
	public Button login;
	public Button logout;
	public Button signUp;
	public Button addProductSubmit;
	public Button shopAddToCart;
	
	public PasswordField signPassword;
	public PasswordField signRepPassword;
	
	public TextArea signAddress;
	
	public TableView<Product> shopTable;
	
	public TableView cartTableView;
	
	public TableColumn shopListNameCol;
	public TableColumn shopListPriceCol;
	public TableColumn shopListCategoryCol;
	public TableColumn cartProductNameCol;
	public TableColumn cartProductCategoryCol;
	public TableColumn cartProductAmountCol;
	public TableColumn cartProductTotalCol;
	
	private Webshop webshop;
	
	public Tab updateCart;
	
	public TextField addProductPrice;
	public TextField username;
	public TextField signUsername;
	public TextField signEmail;
	public TextField signName;
	public TextField signPhone;
	public TextField addProductName;
	public TextField addProductCategory;
	public TextField addProductID;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		webshop = new Webshop();
		
		ObservableList<Product> productList = FXCollections.observableArrayList(webshop.getProductCatalogue().getProducts());
		shopListNameCol.setCellValueFactory(new PropertyValueFactory<>("name"));
		shopListPriceCol.setCellValueFactory(new PropertyValueFactory<>("price"));
		shopListCategoryCol.setCellValueFactory(new PropertyValueFactory<>("category"));
		shopTable.setItems(productList);
		
		cartProductNameCol.setCellValueFactory(new PropertyValueFactory<>("name"));
		cartProductCategoryCol.setCellValueFactory(new PropertyValueFactory<>("category"));
		cartProductAmountCol.setCellValueFactory(new PropertyValueFactory<>("amount"));
		cartProductTotalCol.setCellValueFactory(new PropertyValueFactory<>("total"));
	}

	@FXML
	public void addProduct(ActionEvent event) {
		if (addProductID.getText().matches("\\d*")) {
			if (addProductPrice.getText().matches("(\\d+)[.](\\d{1,2})")) {
				webshop.addProduct(new Product(addProductName.getText(), addProductCategory.getText(),
						Integer.valueOf(addProductID.getText()), Double.valueOf(addProductPrice.getText())));
			} else {
				System.out.println("product Price is not formatted correctly.");
			}
		} else {
			System.out.println("product Price is not formatted correctly.");
		}
	}
	
	@FXML
	public void addToCart(ActionEvent event){
		webshop.addToCart(shopTable.getSelectionModel().getSelectedItem());
	
		
	}
	
	public void updateCartView(Event event) {
		if(updateCart.isSelected()){
			cartTableView.setItems(
					FXCollections.observableArrayList(
							CartTableEntry.getCartList(webshop.getCurrentProfile().getCart())));
		}
	}

	/**
	 * The function runs on a key typed event in the email field, and turns the field a pale green, when email is valid.
	 * @param e The key event triggering the function.
	 */
	@FXML
	void emailVerification(KeyEvent e) {
		if (validateAndPaintEmailField()){
			recolorTextInput(signEmail, APPROVED_TEXT_FIELD_COLOR);
		}
	}

	/**
	 * If all fields are valid, the profile will be created. Whether the creation was successful is currently be printed through sout.
	 * TODO There is currently no error message displayed.
	 *
	 * @param e The event triggering the function.
	 */
	@FXML
	void signUp(ActionEvent e) {
		if (isProfileFieldsValid()) {
			RegisteredProfile profileToRegister = new RegisteredProfile(
					0, signName.getText(),
					signAddress.getText(), signPhone.getText(), signEmail.getText());
			System.out.println(webshop.register(signUsername.getText(), signPassword.getText(), profileToRegister));
		}
	}

	/**
	 * Attempts to find and log in the user from the credentials inserted in the username and password field.
	 * The label notifies the user if the login was successful.
	 *
	 * @param e The event triggering the function.
	 */
	@FXML
	void login(ActionEvent e) {
		if (webshop.login(username.getText(), password.getText())) {
			topLabel.setText("Successfully logged in as " + ((RegisteredProfile) webshop.getCurrentProfile()).getName());
		} else {
			topLabel.setText("User/Password combination does not exist.");
		}
		loggedInLabel.setText("Logged in as: " + webshop.getCurrentProfile().getType());
	}

	@FXML
	void logout(ActionEvent ae) {
		webshop.logout();
	}

	/**
	 * Returns whether the text in all input fields is valid.
	 *
	 * @return true, if all text fields has valid information.
	 */
	private boolean isProfileFieldsValid() {
		return validateAndPaintPasswordFields() && validateAndPaintUsernameField() && validateAndPaintNameField() &&
				validateAndPaintEmailField() && validateAndPaintPhoneField() && validateAndPaintAddressField();
	}

	/**
	 * Validates the password fields, and paints them red if invalid.
	 * Valid password fields has more than 9 characters, contains the same text.
	 *
	 * @return Whether the password fields has valid text.
	 */
	private boolean validateAndPaintPasswordFields() {
		if (signPassword.getText().length() < 8) {
			recolorTextInput(signPassword, INVALID_TEXT_FIELD_COLOR);
			return false;
		}
		if (signPassword.getText().equals(signRepPassword.getText())) {
			recolorTextInput(signPassword, DEFAULT_TEXT_FIELD_COLOR);
			recolorTextInput(signRepPassword, DEFAULT_TEXT_FIELD_COLOR);
			return true;
		} else {
			recolorTextInput(signRepPassword, INVALID_TEXT_FIELD_COLOR);
			return true;
		}
	}

	/**
	 * Validates the username field, and paints it red if invalid.
	 * A valid username field is not empty, and does not already exist in the system.
	 *
	 * @return Whether the username field has valid text.
	 */
	private boolean validateAndPaintUsernameField() {
		if (signUsername.getText().isEmpty() || webshop.usernameExists(username.getText())) {
			recolorTextInput(signUsername, INVALID_TEXT_FIELD_COLOR);
			return false;
		}
		return true;
	}

	/**
	 * Validates the email field, and paints it red if invalid.
	 * A valid email fiels has a valid email address entered.
	 *
	 * @return Whether the email field has valid text.
	 */
	private boolean validateAndPaintEmailField() {
		if (!signEmail.getText().matches("(\\w+)@(\\w+)\\.(\\w+)")) {//(\w+(\.\w+)*)@(\w+)\.(\w+)
			recolorTextInput(signEmail, INVALID_TEXT_FIELD_COLOR);
			return false;
		}
		return true;
	}

	/**
	 * Validates the name field, and paints it red if invalid.
	 * a valid name filed is not empty.
	 *
	 * @return Whether the name field has valid text.
	 */
	private boolean validateAndPaintNameField() {
		if (signName.getText().isEmpty()) {
			recolorTextInput(signName, INVALID_TEXT_FIELD_COLOR);
			return false;
		}
		return true;
	}

	/**
	 * Validates the Phone field, and paints it red if invalid.
	 * a valid phone field has no more or less then 8 digits.
	 *
	 * @return Whether the phone field has valid text.
	 */
	private boolean validateAndPaintPhoneField() {
		if (!signPhone.getText().matches("\\d{8}")) {
			recolorTextInput(signPhone, INVALID_TEXT_FIELD_COLOR);
			return false;
		}
		return true;
	}

	/**
	 * Validates the Address field and paints it red if invalid.
	 * A valid address is not empty.
	 *
	 * @return Whether the address field has valid text.
	 */
	private boolean validateAndPaintAddressField() {
		if (signAddress.getText().isEmpty()) {
			recolorTextInput(signAddress, INVALID_TEXT_FIELD_COLOR);
			return false;
		}
		return true;
	}

	/**
	 * Recolors a text input field.
	 *
	 * @param textInput the input field to recolor.
	 * @param hexColor  The color value to paint field.
	 */
	private void recolorTextInput(TextInputControl textInput, String hexColor) {
		textInput.setBackground(new Background(new BackgroundFill(Paint.valueOf(hexColor), null, null)));
	}
	
	
}
