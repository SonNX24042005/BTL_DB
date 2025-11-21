# Cách chạy trên Windows
- Bước 1
```bash
cd DB\v2\sql
Get-Content create_tables.sql | mysql -u root -p
```
- Bước 2
```bash
mysql -u root -p -e "SET GLOBAL local_infile = 1;"
cd CSV_Data
Get-Content import_data_from_csv.sql | mysql --local-infile=1 -u root -p qldt
```

# Cách chạy trên Ubuntu
- Bước 1
```bash
cd DB/v2/sql
cat create_tables.sql | mysql -u root -p
# Hoặc dùng:
# mysql -u root -p < create_tables.sql
```
- Bước 2
```bash
mysql -u root -p -e "SET GLOBAL local_infile = 1;"
cd CSV_Data
cat import_data_from_csv.sql | mysql --local-infile=1 -u root -p qldt
# Hoặc dùng:
# mysql --local-infile=1 -u root -p qldt < import_data_from_csv.sql
```