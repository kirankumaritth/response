#!/bin/bash
set -e                              # ❗ Exit on error
source .env                         # 📥 Load environment variables

echo "📦 Creating database and users..."

sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS $DB_NAME;              -- 🗑 Remove existing DB
DROP USER IF EXISTS $ADMIN_USER;              -- 🗑 Remove old users
DROP USER IF EXISTS $VIEW_USER;

CREATE DATABASE $DB_NAME;                     -- 🆕 Create new database
CREATE USER $ADMIN_USER WITH ENCRYPTED PASSWORD '$ADMIN_PASS'; -- 👤 Admin
CREATE USER $VIEW_USER WITH ENCRYPTED PASSWORD '$VIEW_PASS';   -- 👁️ View-only

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $ADMIN_USER;     -- ✅ Full access to admin
EOF

echo "📄 Running schema and object creation..."

sudo -u postgres psql -d $DB_NAME -f schema.sql       # 📚 Create tables
sudo -u postgres psql -d $DB_NAME -f functions.sql    # 🧠 Create function
sudo -u postgres psql -d $DB_NAME -f views.sql        # 👁️ Create view

echo "🔐 Granting view access to view_user..."

sudo -u postgres psql -d $DB_NAME <<EOF
GRANT CONNECT ON DATABASE $DB_NAME TO $VIEW_USER;
GRANT USAGE ON SCHEMA public TO $VIEW_USER;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO $VIEW_USER;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO $VIEW_USER;
EOF

echo "✅ Setup complete!"
