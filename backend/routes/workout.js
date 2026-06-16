const express = require("express");
const router = express.Router();

const {auth} = require("../middleware/tokenAuth");
const {
    createWorkout,
    getMyWorkouts,
    showWorkout,
    deleteWorkout,
    deleteExercise
} = require("../connections/workout");

router.post("/createWorkout", auth, createWorkout);
router.get("/myWorkouts", auth, getMyWorkouts);
router.get("/workout/:workoutId", auth, showWorkout);
router.delete("/workout/:workoutId", auth, deleteWorkout);
router.delete(
    "/exercise/:exerciseId",
    auth,
    deleteExercise
);
module.exports = router;