# 📚 Compass Mining Code Screen – PostgreSQL Project Setup & Execution Steps

---

## ✅ **Section 1: Choose Your Environment**

### 🖥 Option 1: Use AWS EC2 (Ubuntu 24.04)

1. 🔐 Login to AWS Console → [https://console.aws.amazon.com](https://console.aws.amazon.com)
2. 🚀 Launch EC2 Instance
   - ✅ AMI: Ubuntu 24.04 LTS
   - 💾 Instance: `t2.micro` (Free tier)
   - 🔐 Security Group: Allow port `22` (SSH)
   - 💽 Storage: Min 8GB
3. 🔗 Connect to EC2
   ```bash
   chmod 400 your-key.pem             # Secure the key file
   ```
   ```bash
   ssh -i "your-key.pem" ubuntu@<IP>  # Connect to your instance
   ```

---

### 💻 Option 2: Use WSL on Windows

```powershell
wsl --install -d Ubuntu    # Install Ubuntu via WSL
```

Then open Ubuntu from Start Menu and you're good to go!

---

## ✅ **Validation Check**

```bash
lsb_release -a   # Check Linux version
```

✅ Expected:
```
Distributor ID: Ubuntu
Description:    Ubuntu 24.04 LTS
```

---

## 🔧 Step 1: Install PostgreSQL

```bash
sudo apt update && sudo apt upgrade -y      # 🔄 Refresh & upgrade package list
```
```bash
sudo apt install postgresql postgresql-contrib -y   # 📦 Install PostgreSQL
```

🔍 Check status:
```bash
sudo systemctl status postgresql   # ✅ Confirm it's running
```

🔄 If not:
```bash
sudo systemctl start postgresql    # ▶️ Start PostgreSQL service
```

---

## 📁 Step 2: Create Project Directory & Files

```bash
mkdir book-db-project && cd book-db-project   # 📁 Create and enter directory
```

```bash
touch .env setup.sh schema.sql cleanup.sh functions.sql views.sql README.md
```

📂 Folder structure:
```
book-db-project/
├── .env
├── setup.sh
├── schema.sql
├── cleanup.sh
├── functions.sql
├── views.sql
└── README.md
```

---

```bash
chmod +x setup.sh
```

```bash
chmod +x cleanup.sh
```

## 🚀 Run the Setup

```bash
./setup.sh    # 🧠 Auto runs .env, creates DB, users, tables, views, etc.
```


## ✅ Verification Steps

### 👥 Check PostgreSQL Users

```bash
sudo -u postgres psql -c "\du"   # 🔍 List users
```

Expected:
```
 admin_user | 
 view_user  |
```

---

### 💽 Check Databases

```bash
sudo -u postgres psql -c "\l"   # 📂 List databases
```

---

### 📊 Check Tables

```bash
sudo -u postgres psql -d books_db -c "\dt"
```

Should show:
```
 public | books | table | postgres
```

---

### 🧠 Check Function

```bash
sudo -u postgres psql -d books_db -c "\df"
```

🔍 Run it:
```bash
sudo -u postgres psql -d books_db -c "SELECT total_books();"
```

---

### 👁️ Check Views

```bash
sudo -u postgres psql -d books_db -c "\dv"
```
```bash
sudo -u postgres psql -d books_db -c "SELECT * FROM books_summary;"
```

🧪 If empty, insert a book:

```bash
sudo -u postgres psql -d books_db -c \
```
```bash
"INSERT INTO books (title, subtitle, author, publisher) VALUES ('PostgreSQL Guide', 'For Beginners', 'Jane Doe', 'OpenSource Press');"
```

---

### 🔐 Test View-Only User Access

```bash
psql -U view_user -d books_db -h localhost
```
```bash
SELECT * FROM books_summary;
```

Or quick test:
```bash
sudo -u postgres psql -d books_db -U view_user -c "SELECT * FROM books_summary;"
```

> 🛠 If you face password errors, edit `pg_hba.conf` or reset password via SQL.

---

## 🧼 Run Cleanup

```bash
./cleanup.sh    # 🧹 Drops DB & users created during setup
```

---

