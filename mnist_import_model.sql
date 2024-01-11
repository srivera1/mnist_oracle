-- Sergio Rivera 2023
--
-- Importing a saved model
--
--

-- Importing the model from a folder with right permits:
-- $ sudo chown -R oracle:oinstall /tmp/exported_mnist_trained

-- connect as system user
conn mnist/mnist@localhost:1521/mnist;
CREATE OR REPLACE DIRECTORY OMLDIR AS '/tmp/exported_mnist_trained';
SELECT * FROM all_directories WHERE directory_name = 'OMLDIR';

-- You may drop the model if already existing
exec dbms_data_mining.drop_model('DEEP_LEARNING_MODEL');

-- Import
BEGIN
  dbms_data_mining.import_model(
                   filename => 'DEEP_NN_v101.dmp',
                   directory => 'OMLDIR');
  COMMIT;
END;
/
SELECT model_name FROM user_mining_models;


