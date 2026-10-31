-- Read-only account for the automated grading script.
-- EC2 (local MySQL):   sudo mysql < readonly_user.sql
-- RDS:                 mysql -h <rds-endpoint> -u admin -p < readonly_user.sql
-- Change the password before running.
CREATE USER IF NOT EXISTS 'evaluator'@'%' IDENTIFIED BY 'Eval@12345';
GRANT SELECT ON fridgechef.* TO 'evaluator'@'%';
FLUSH PRIVILEGES;
