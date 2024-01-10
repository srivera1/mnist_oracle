-- Sergio Rivera 2023
--
-- Pluggable Database open
--
--

conn sys/debianOracle@localhost:1521/free as sysdba;
alter pluggable database mnist open;
conn mnist/mnist@localhost:1521/mnist;
