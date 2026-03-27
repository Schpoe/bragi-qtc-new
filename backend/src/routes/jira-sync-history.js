const express = require('express');
const prisma = require('../prisma');
const { attachCrud } = require('../lib/crud');
const { requireAuth } = require('../middleware/auth');

const router = express.Router();

// Return most recent 50 entries sorted descending
router.get('/', requireAuth, async (_req, res) => {
  try {
    const items = await prisma.jiraSyncHistory.findMany({
      orderBy: { created_at: 'desc' },
      take: 50,
    });
    res.json(items);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

attachCrud(router, prisma.jiraSyncHistory);
module.exports = router;
