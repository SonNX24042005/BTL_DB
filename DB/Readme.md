- Bước 1
```bash
Get-Content Create_Tables_Optimized.sql | mysql -u root -p
```
- Bước 2
```bash
# Bật local_infile (chỉ cần 1 lần)
mysql -u root -p -e "SET GLOBAL local_infile = 1;"

# Import CSV
Get-Content import_from_csv_ordered.sql | mysql --local-infile=1 -u root -p qldt
```
