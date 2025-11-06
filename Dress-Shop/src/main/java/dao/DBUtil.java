package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {

    private static final String DB_TYPE = System.getenv("DB_TYPE") != null
            ? System.getenv("DB_TYPE").toLowerCase()
            : "mysql"; // default local = MySQL

    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;
    private static final String DRIVER;

    static {
        if ("postgresql".equals(DB_TYPE)) {
            // 🌐 For Render (PostgreSQL)
            URL = System.getenv("DB_URL") != null
                    ? System.getenv("DB_URL")
                    : "jdbc:postgresql://dpg-cp123abc12345a7c123.oregon-postgres.render.com:5432/dress_shop";
            USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "dress_shop_user";
            PASSWORD = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "abcd1234abcd1234abcd1234";
            DRIVER = "org.postgresql.Driver";
        } else {
            // 💻 For Local (MySQL)
            URL = "jdbc:mysql://localhost:3306/Dress_Shop?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            USER = "root";
            PASSWORD = "Root@123";
            DRIVER = "com.mysql.cj.jdbc.Driver";
        }

        try {
            Class.forName(DRIVER);
            System.out.println("✅ Loaded DB Driver: " + DRIVER);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Connected to: " + URL);
            return con;
        } catch (Exception e) {
            System.err.println("❌ Database connection failed!");
            e.printStackTrace();
            return null;
        }
    }
}
