const { Client } = require("pg");
const con = new Client({
    host: "localhost",
    user: "postgres",
    port: 5432,
    password: "Comeoncity@28",
    database: "test"
});
module.exports = con;