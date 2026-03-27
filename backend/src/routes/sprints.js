const express = require('express');
const prisma = require('../prisma');
const { attachCrud } = require('../lib/crud');

const router = express.Router();
attachCrud(router, prisma.sprint, ['team_id', 'quarter', 'is_cross_team', 'is_template']);
module.exports = router;
