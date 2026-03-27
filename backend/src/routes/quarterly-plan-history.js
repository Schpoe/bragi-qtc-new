const express = require('express');
const prisma = require('../prisma');
const { attachCrud } = require('../lib/crud');

const router = express.Router();
attachCrud(router, prisma.quarterlyPlanHistory, ['quarter', 'team_id', 'team_member_id', 'work_area_id']);
module.exports = router;
