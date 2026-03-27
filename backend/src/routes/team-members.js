const express = require('express');
const prisma = require('../prisma');
const { attachCrud } = require('../lib/crud');

const router = express.Router();
attachCrud(router, prisma.teamMember, ['team_id']);
module.exports = router;
