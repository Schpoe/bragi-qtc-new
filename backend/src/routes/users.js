const express = require('express');
const bcrypt = require('bcryptjs');
const prisma = require('../prisma');
const { requireAuth, requireAdmin } = require('../middleware/auth');

const router = express.Router();

const strip = ({ password_hash, ...rest }) => rest;

router.get('/', requireAuth, async (req, res) => {
  try {
    const users = await prisma.user.findMany({ orderBy: { created_at: 'asc' } });
    res.json(users.map(strip));
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/:id', requireAuth, async (req, res) => {
  try {
    const user = await prisma.user.findUnique({ where: { id: req.params.id } });
    if (!user) return res.status(404).json({ message: 'Not found' });
    res.json(strip(user));
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post('/', requireAdmin, async (req, res) => {
  try {
    const { password, ...data } = req.body;
    if (!password) return res.status(400).json({ message: 'password required' });
    const password_hash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: { ...data, email: data.email.toLowerCase(), password_hash }
    });
    res.status(201).json(strip(user));
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

router.put('/:id', requireAuth, async (req, res) => {
  try {
    const { password, password_hash, ...data } = req.body;
    const update = { ...data };
    if (password) update.password_hash = await bcrypt.hash(password, 10);
    const user = await prisma.user.update({ where: { id: req.params.id }, data: update });
    res.json(strip(user));
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

router.delete('/:id', requireAdmin, async (req, res) => {
  try {
    await prisma.user.delete({ where: { id: req.params.id } });
    res.json({ ok: true });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;
