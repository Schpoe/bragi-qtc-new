const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

async function main() {
  const email = process.env.SEED_ADMIN_EMAIL || 'admin@example.com';
  const password = process.env.SEED_ADMIN_PASSWORD || 'changeme123';

  const existing = await prisma.user.findUnique({ where: { email } });
  if (existing) {
    console.log(`Admin user already exists: ${email}`);
    return;
  }

  const password_hash = await bcrypt.hash(password, 10);
  await prisma.user.create({
    data: { email, password_hash, full_name: 'Admin', role: 'admin', managed_team_ids: [] },
  });

  console.log(`Created admin user: ${email}`);
  console.log(`Password: ${password}`);
  console.log('Change this password after first login!');
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
