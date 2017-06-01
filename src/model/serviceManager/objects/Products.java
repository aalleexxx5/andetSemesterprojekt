package model.serviceManager.objects;

import model.product.Product;
import model.serviceManager.DatabaseInterface;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Kentv on 30-05-2017.
 */
public class Products
{
    private static String selectObject = "SELECT * FROM products_table WHERE identities=[0];";
    private static String SelectProductIdentities = "SELECT identities FROM products_table;";

    private int    identity = -1;
    private String product_name = "Placeholder";
    private String category_names = "Unknown";
    private double product_price = 0.0f;

    public Products()
    {

    }

    public Products( int id, DatabaseInterface db_interface )
    {
        if(!db_interface.Open())
            System.out.println("Error - Products - Generating Product - Opening Connection");

        String sql = selectObject.replace("[0]", Integer.toString( id ) );

        RetrieveTable( sql, db_interface );

        db_interface.Close();
    }

    private void RetrieveTable( String sql, DatabaseInterface db_interface )
    {
        // Start variables
        Connection c = db_interface.returnConnector();

        Statement stmt;
        ResultSet rs;

        try
        {
            stmt = c.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next())
            {
                this.setProduct_name(rs.getString("product_names"));
                this.setCategory_names(rs.getString("category_names"));
                this.setProduct_price(rs.getDouble("price"));
                this.setIdentity(rs.getInt("identities"));
            }


        }
        catch (Exception ex)
        {
            System.out.println(ex.getMessage());
        }

    }

    // Setters
    public void setIdentity(int x)
    {
        this.identity = x;
    }
    public void setProduct_name(String s)
    {
        this.product_name = s;
    }
    public void setProduct_price(double d)
    {
        this.product_price = d;
    }
    public void setCategory_names(String s)
    {
        this.category_names = s;
    }
    public void set(Products p)
    {
        set(p.getIdentity(), p.getProduct_name(), p.getCategory_names(), p.getProduct_price());
    }

    public void set( int identity,
                     String product_name,
                     String Category,
                     Double price )
    {
        setIdentity(identity);
        setProduct_name(product_name);
        setCategory_names(Category);
        setProduct_price(price);
    }

    // Getters
    public String getCategory_names()
    {
        return this.category_names;
    }

    public String getProduct_name()
    {
        return this.product_name;
    }

    public int getIdentity()
    {
        return this.identity;
    }

    public double getProduct_price()
    {
        return this.product_price;
    }

    public Product getModelProduct()
    {
        Product p = new Product( product_name,
                                 category_names,
                                 identity,
                                 product_price );
        return p;
    }

    // Static functions
    static String insertNewProduct = "INSERT INTO catalog.product(name, price, category) VALUES ('[0]', [1], [2]);";
    public static boolean addProduct( Product modelProduct, DatabaseInterface db_interface )
    {
        db_interface.Open();

        Connection c = db_interface.returnConnector();

        Categories cg = Categories.existCategory( modelProduct.getCategory(), db_interface );

        if( cg == null )
            return false;

        boolean inserted = false;

        try {
            Statement stmt = c.createStatement();

            String sql = insertNewProduct;

            sql = sql.replace("[0]", modelProduct.getName() );
            sql = sql.replace("[1]", Double.toString( modelProduct.getPrice() ) );
            sql = sql.replace("[2]", Integer.toString( cg.getIdentity() ) );

            System.out.println(sql);

            stmt.executeUpdate(sql);

            inserted = true;
        }
        catch (Exception ex)
        {
            System.out.print(ex.getMessage());
        }
        finally
        {
            db_interface.Close();
        }

        return inserted;
    }

    public static boolean removeProduct( Product modelProduct, DatabaseInterface db_interface )
    {
        throw new NotImplementedException();
    }

    public static List<Integer> getProductIdentities(DatabaseInterface db_interface)
    {
        db_interface.Open();

        Connection c = db_interface.returnConnector();

        Statement stmt;
        ResultSet rs;

        List<Integer> listOfIdentities = new ArrayList<Integer>();

        try
        {
            stmt = c.createStatement();
            rs = stmt.executeQuery( SelectProductIdentities );

            while (rs.next())
            {
                listOfIdentities.add( rs.getInt("identities") );
            }

            rs.close();
            stmt.close();

        }
        catch (Exception ex)
        {

        }
        finally {
            db_interface.Close();
        }

        return listOfIdentities;
    }

}
