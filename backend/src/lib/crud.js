const { requireAuth } = require('../middleware/auth');

/**
 * Build a standard CRUD router for a Prisma model.
 * @param {import('express').Router} router
 * @param {object} model - Prisma model delegate (e.g. prisma.team)
 * @param {string[]} [filterableFields] - Fields allowed as query-string filters
 */
function attachCrud(router, model, filterableFields = []) {
  // List
  router.get('/', requireAuth, async (req, res) => {
    try {
      const where = {};
      for (const field of filterableFields) {
        if (req.query[field] !== undefined) {
          where[field] = req.query[field];
        }
      }
      const items = await model.findMany({ where, orderBy: { created_at: 'asc' } });
      res.json(items);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  });

  // Get one
  router.get('/:id', requireAuth, async (req, res) => {
    try {
      const item = await model.findUnique({ where: { id: req.params.id } });
      if (!item) return res.status(404).json({ message: 'Not found' });
      res.json(item);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  });

  // Create
  router.post('/', requireAuth, async (req, res) => {
    try {
      const item = await model.create({ data: req.body });
      res.status(201).json(item);
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  });

  // Update
  router.put('/:id', requireAuth, async (req, res) => {
    try {
      const item = await model.update({ where: { id: req.params.id }, data: req.body });
      res.json(item);
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  });

  // Delete
  router.delete('/:id', requireAuth, async (req, res) => {
    try {
      await model.delete({ where: { id: req.params.id } });
      res.json({ ok: true });
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  });
}

module.exports = { attachCrud };
