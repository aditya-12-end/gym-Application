const con = require("../main");

async function createWorkout(req, res) {
     console.log("CREATE WORKOUT HIT");
    console.log("USER:", req.user);
    console.log("BODY:", req.body);
    const { workoutName, targetedMuscle, exercises } = req.body;

  
    try {
        await con.query(`
            CREATE TABLE IF NOT EXISTS workouts (
                id SERIAL PRIMARY KEY,
                user_id INT NOT NULL,
                workout_name VARCHAR(100) NOT NULL,
                targeted_muscle VARCHAR(100) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id)
                REFERENCES users(id)
                ON DELETE CASCADE
            )
        `);

        await con.query(`
            CREATE TABLE IF NOT EXISTS exercises (
                id SERIAL PRIMARY KEY,
                workout_id INT NOT NULL,
                exercise_name VARCHAR(100) NOT NULL,
                sets INT NOT NULL,
                reps INT NOT NULL,
                rest_time INT NOT NULL,
                FOREIGN KEY (workout_id)
                REFERENCES workouts(id)
                ON DELETE CASCADE
            )
        `);

 const workoutResult = await con.query(
    `INSERT INTO workouts (
        user_id,
        workout_name,
        targeted_muscle
    )
    VALUES ($1,$2,$3)
    RETURNING *`,
    [
        req.user.userId,
        workoutName,
        targetedMuscle
    ]
);

        const workoutId = workoutResult.rows[0].id;

        for (const exercise of exercises) {
            await con.query(
                `INSERT INTO exercises(
                    workout_id,
                    exercise_name,
                    sets,
                    reps,
                    rest_time
                )
                VALUES($1, $2, $3, $4, $5)`,
                [
                    workoutId,
                    exercise.exerciseName,
                    exercise.sets,
                    exercise.reps,
                    exercise.restTime
                ]
            );
        }

        return res.status(201).json({
            message: "Workout created successfully",
            workoutId
        });

    } catch (error) {
        console.error(error);

        return res.status(500).json({
            error: error.message
        });
    }
}

async function getMyWorkouts(req, res) {
    const userId = req.user.userId;

    try {
       const result = await con.query(`
        SELECT
    w.id,
    w.workout_name,
    w.targeted_muscle,
    w.created_at,
    COALESCE(
        json_agg(
            json_build_object(
                'id', e.id,
                'exercise_name', e.exercise_name,
                'sets', e.sets,
                'reps', e.reps,
                'rest_time', e.rest_time
            )
        ) FILTER (WHERE e.id IS NOT NULL),
        '[]'
    ) AS exercises
FROM workouts w
LEFT JOIN exercises e
ON w.id = e.workout_id
WHERE w.user_id = $1
GROUP BY w.id
ORDER BY w.created_at DESC
`,[userId]);


        return res.status(200).json(result.rows);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

async function showWorkout(req, res) {
    const { workoutId } = req.params;
    const userId = req.user.userId;

    try {
        const workoutResult = await con.query(
            `SELECT *
FROM workouts
WHERE id = $1
AND user_id = $2
           `,
            [workoutId,userId]
        );

        if (workoutResult.rows.length === 0) {
            return res.status(404).json({
                message: "Workout not found"
            });
        }

        const exercisesResult = await con.query(
            `SELECT *
             FROM exercises
             WHERE workout_id = $1`,
            [workoutId]
        );

        return res.status(200).json({
            workout: workoutResult.rows[0],
            exercises: exercisesResult.rows
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

async function deleteWorkout(req, res) {
    const { workoutId } = req.params;

    try {
        const result = await con.query(
            `DELETE FROM workouts
WHERE id = $1
AND user_id = $2
RETURNING *`,
            [workoutId,req.user.userId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Workout not found"
            });
        }

        return res.status(200).json({
            message: "Workout deleted successfully"
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}
async function deleteExercise(req, res) {
    const { exerciseId } = req.params;

    try {
        const result = await con.query(
            `DELETE FROM exercises
             WHERE id = $1
             RETURNING *`,
            [exerciseId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Exercise not found"
            });
        }

        return res.status(200).json({
            message: "Exercise deleted successfully"
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

module.exports = {
    createWorkout,
    getMyWorkouts,
    showWorkout,
    deleteWorkout,
    deleteExercise
};