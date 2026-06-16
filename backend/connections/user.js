const con = require('../main');
const jwt=require("jsonwebtoken");
async function createUser(req, res) {
    const { email, password } = req.body;

    try {
    
        const existingUser = await con.query(
            "SELECT * FROM users WHERE email = $1",
            [email]
        );

        if (existingUser.rows.length > 0) {
            return res.status(409).json({
                message: "Email already exists"
            });
        }

  
        await con.query(
            "INSERT INTO users(email, password) VALUES ($1, $2)",
            [email, password]
        );

        res.status(201).json({
            message: "User created successfully"
        });

    } catch (error) {
        res.status(500).json({
            error: error.message
        });
    }
}


async function loginUser(req, res) {
    const { email, password } = req.body;

    try {

        const result = await con.query(
            "SELECT * FROM users WHERE email = $1",
            [email]
        );

        if (result.rows.length === 0) {
            return res.status(401).json({
                message: "Invalid email or password"
            });
        }

        const user = result.rows[0];

        if (user.password !== password) {
            return res.status(401).json({
                message: "Invalid email or password"
            });
        }

        const token = jwt.sign(
            {
                userId: user.id,
                email: user.email
            },
            "mySecretKey",
            {
                expiresIn: "7d"
            }
        );

        return res.status(200).json({
            message: "Login successful",
            token: token
        });

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
}
async function getData(req,res){
    const result = await con.query(
        "SELECT * FROM users WHERE email=$1",
        [req.user.email]
    );

    res.json(result.rows[0]);
}
module.exports = { createUser,loginUser ,getData};