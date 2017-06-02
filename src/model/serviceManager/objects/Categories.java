package model.serviceManager.objects;

import model.serviceManager.DatabaseInterface;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Created by Kentv on 30-05-2017.
 */
public class Categories {
	static String sqlGetproducts = "SELECT * FROM catalog;";
	static String getSQLCategory = "SELECT * FROM catalog.product_category WHERE name='[0]';";
	int Identity = -1;
	String CategoryName = "";
	
	public Categories() {
		
	}
	
	public Categories(int identity, String name) {
		setCategoryName(name);
		setIdentity(identity);
	}
	
	public static String[] getProductsCategories(DatabaseInterface DI) {
		DI.Open();
		
		Connection c = DI.returnConnector();
		
		Statement stmt = null;
		ResultSet rs = null;
		
		ArrayList<String> list = new ArrayList<String>();
		
		try {
			stmt = c.createStatement();
			rs = stmt.executeQuery(sqlGetproducts);
			
			while (rs.next()) {
				String s = rs.getString("name");
				list.add(s);
			}
		} catch (Exception ex) {
			DI.Close();
			
			System.out.print(ex.getMessage());
			return null;
		} finally {
			DI.Close();
		}
		
		String[] retVal = new String[list.size()];
		retVal = list.toArray(retVal);
		
		return retVal;
	}
	
	public static Categories existCategory(String name, DatabaseInterface di) {
		Categories ret = null;
		
		di.Open();
		
		Connection c = di.returnConnector();
		
		try {
			Statement stmt;
			ResultSet rs;
			
			stmt = c.createStatement();
			
			rs = stmt.executeQuery(getSQLCategory.replace("[0]", name));
			
			Categories cgs = null;
			
			while (rs.next()) {
				cgs = new Categories(rs.getInt("identities"),
						rs.getString("name"));
			}
			
			ret = cgs;
		} catch (Exception ex) {
			System.out.print(ex.getMessage());
		} finally {
			di.Close();
		}
		
		return ret;
	}
	
	public int getIdentity() {
		return Identity;
	}
	
	public void setIdentity(int id) {
		Identity = id;
	}
	
	public String getCategoryName() {
		return CategoryName;
	}
	
	public void setCategoryName(String name) {
		CategoryName = name;
	}
}
