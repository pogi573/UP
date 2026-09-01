const fs = require("fs");
const path = require("path");
const mysql = require("mysql2/promise");
require("dotenv").config();

async function setupDatabase() {
    const connection = await mysql.createConnection({
        host: process.env.DB_HOST || "localhost",
        user: process.env.DB_USER || "root",
        password: process.env.DB_PASSWORD || "",
        multipleStatements: true
    });
    const schemaPath = path.join(__dirname, "CREATE DATABASE IF NOT EXISTS school_man.sql");
    try {
        await connection.query(fs.readFileSync(schemaPath, "utf8"));
        console.log("Database schema is ready.");
    } finally {
        await connection.end();
    }
}

setupDatabase().catch((error) => {
    console.error(`Database setup failed: ${error.message}`);
    process.exitCode = 1;
});
