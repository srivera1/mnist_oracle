-- Sergio Rivera 2023
--
-- Saving a model
--
--

-- 1) Create a directory and change owner:
-- $ mkdir /tmp/exported_mnist_trained
-- $ sudo chown -R oracle:oinstall /tmp/exported_mnist_trained

-- 2) Exporting the model
conn mnist/mnist@localhost:1521/mnist_trained;
select * from neural_network_settings;
SELECT owner, model_name, mining_function, algorithm FROM all_mining_models where OWNER='MNIST';
 
 -- connect as system user
conn sys/debianOracle@localhost:1521/mnist_trained AS SYSDBA;
CREATE OR REPLACE DIRECTORY OMLDIR AS '/tmp/exported_mnist_trained';
GRANT READ, WRITE ON DIRECTORY OMLDIR TO MNIST;
SELECT * FROM all_directories WHERE directory_name = 'OMLDIR';

-- connect as MNIST
conn mnist/mnist@localhost:1521/mnist_trained;
BEGIN dbms_data_mining.export_model(
      filename =>'DEEP_NN_v1', 
      directory=>'OMLDIR'); END;
/


