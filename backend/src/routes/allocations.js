const express = require('express');
const prisma = require('../prisma');
const { attachCrud } = require('../lib/crud');

const router = express.Router();
attachCrud(router, prisma.allocation, ['sprint_id', 'team_member_id', 'work_area_id']);
module.exports = router;
