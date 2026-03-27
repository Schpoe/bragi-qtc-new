/**
 * Run safe column renames BEFORE prisma db push so that prisma sees the schema
 * already matches and avoids dropping + recreating columns (which loses data).
 */
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  await prisma.$executeRawUnsafe(`
    DO $$
    BEGIN
      -- Rename Allocation.percentage -> percent
      IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'Allocation' AND column_name = 'percentage'
      ) THEN
        ALTER TABLE "Allocation" RENAME COLUMN "percentage" TO "percent";
      END IF;

      -- Rename QuarterlyAllocation.percentage -> percent
      IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'QuarterlyAllocation' AND column_name = 'percentage'
      ) THEN
        ALTER TABLE "QuarterlyAllocation" RENAME COLUMN "percentage" TO "percent";
      END IF;
    END $$;
  `);
  console.log('prepare-schema: column renames done');
}

main()
  .catch(e => { console.error('prepare-schema error:', e); process.exit(1); })
  .finally(() => prisma.$disconnect());
