<h1>Solving MNIST with ORACLE database</h1>

These sql files will create a Pluggable DB and the needed configuration to create a NN model for the MNIST database with sql*plus.

This example will run directly on this virtual machine:
https://github.com/srivera1/debianOracleFree

<h3>Steps:</h3>

0) $ git clone git@github.com:srivera1/mnist_oracle.git
1) $ cd mnist_oracle
2) $ tar -xf mnist_test_INSERT.sql.tar.gz
3) $ tar -xf mnist_train_INSERT.sql.tar.gz
4) replace "FREE" (ORACLE 23c) by "XE" (ORACLE 21c) if needed (at mnist_create_pluggable.sql and mnist_open.sql)
5) replace port 1521, host and sys password if needed (at mnist_create_pluggable.sql and mnist_open.sql):

    - mnist/mnist@localhost:1521/mnist;
    - connect sys/debianOracle@localhost:1521/FREE as sysdba;

6) $ sqlplus
7) SQL> @mnist_create_pluggable

<h3>Files:</h3>

- mnist_create_pluggable.sql
    - creates pluggable database
    - calls mnist.sql

- mnist.sql
    - creates tables
    - calls
        - mnist_test_INSERT.sql
        - mnist_train_INSERT.sql
        - mnist_train_NN.sql

- mnist_test_INSERT.sql
    -  insert data into test table

- mnist_train_INSERT.sql
    -  insert data into train table

- mnist_train_NN.sql
    -  configurates the a Neural Network as model
    -  trains the model
    -  calculates errors

- mnist_open.sql
    -  quick open de pluggable if already created

- mnist_get_category.sql
    -  model execution example

- mnist_export_model.sql
    -  model saving script

- mnist_import_model.sql
    -  importing a saved model

- exported_mnist_trained.sql
    -  folder containing saved models
    -  models here may be imported to the database
       with the script mnist_import_model.sql


<h3>TODO:</h3>

- Improve comments
- README.md
    
<h3>Resources:</h3>

- http://yann.lecun.com/exdb/mnist/

## License

This project is licensed under the [MIT](./LICENSE)