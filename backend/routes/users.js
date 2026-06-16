const express = require('express');
const { createUser,loginUser ,getData} = require('../connections/user');
const{auth}=require('../middleware/tokenAuth');
const router = express.Router();

router.post('/createUser', createUser);
router.post('/loginUser',loginUser);
router.get('/getUser',auth,getData);
module.exports = router;