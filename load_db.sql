/* Load MySQL with RTTM Data */

--CREATE DATABASE blued;

mysql -u root -p blued < ~/code/MassDOTHack/MassDOT-RTTM-Data/MassDOT_pairs_10-1-12_to_1-1-13.sql

mysql -u root -p -U blued --force < ~/code/MassDOTHack/MassDOT-RTTM-Data/MassDOT_pairs_10-1-12_to_1-1-13.sql

mysql -u root -U blued --force < ~/code/MassDOTHack/MassDOT-RTTM-Data/MassDOT_pairs_4-1-13_to_6-1-13.sql
mysql -u root -U blued --force < ~/code/MassDOTHack/MassDOT-RTTM-Data/MassDOT_pairs_6-1-12_to_10-1-12.sql
mysql -u root -U blued --force < ~/code/MassDOTHack/MassDOT-RTTM-Data/MassDOT_pairs_6-1-13_to_8-1-13.sql
mysql -u root -U blued --force < ~/code/MassDOTHack/MassDOT-RTTM-Data/MassDOT_pairs_8-1-13_to_10-1-13.sql




