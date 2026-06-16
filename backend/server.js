const express = require("express");
const con = require('./main');

const app = express();

const authRoute = require("./routes/users");
const workoutRoute=require("./routes/workout")
app.use(express.json());

app.use('/auth', authRoute);
app.use('/workout',workoutRoute)
con.connect()
    .then(() => console.log("Connected"))
    .catch(err => console.log(err));

app.listen(3000, () => {
    console.log("Server running on port 3000");
});