const express = require('express');
const prisma = require('../prisma');
const { attachCrud } = require('../lib/crud');

const router = express.Router();
attachCrud(router, prisma.workArea, ['leading_team_id', 'type']);
module.exports = router;
