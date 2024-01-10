-- Sergio Rivera 2023
--
-- Model generation, training, error calculation
--
--

!clear

DROP TABLE neural_network_settings;
CREATE TABLE neural_network_settings (
    setting_name    VARCHAR2(1000),
    setting_value   VARCHAR2(1000)
);

BEGIN
    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.prep_auto,
        dbms_data_mining.prep_auto_on
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.algo_name,
        dbms_data_mining.algo_neural_network
    );
    
    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_SOLVER,
-- One of the following strings:
--     NNET_SOLVER_ADAM
--     NNET_SOLVER_LBFGS
-- Specifies the method of optimization.
-- The default value is system determined.
-- CUADR_ERR_TOTAL <--> NNET_SOLVER_LBFGS
-- ---------------
--       55.697495
-- CUADR_ERR_TOTAL <--> NNET_SOLVER_ADAM
-- ---------------
--      88.9696444
        'NNET_SOLVER_LBFGS'
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_ACTIVATIONS,
-- One or more of the following strings:
--     NNET_ACTIVATIONS_ARCTAN
--     NNET_ACTIVATIONS_BIPOLAR_SIG
--     NNET_ACTIVATIONS_LINEAR
--     NNET_ACTIVATIONS_LOG_SIG
--     NNET_ACTIVATIONS_RELU
--     NNET_ACTIVATIONS_TANH
--  Specifies the activation functions for the hidden layers. You can specify a single activation function, which is then applied to each hidden layer, or you can speify an activation function for each layer individually. Different layers can have different activation functions.
--  To apply a different activation function to one or more of the layers, you must specify an activation function for each layer. The number of activation functions you specify must be consistent with the NNET_HIDDEN_LAYERS and NNET_NODES_PER_LAYER values.
--  For example, if you have three hidden layers, you could specify the use of the same activation function for all three layers with the following settings value:
--  ('NNET_ACTIVATIONS', 'NNET_ACTIVATIONS_TANH')
--  The following settings value specifies a different activation function for each layer:
--  ('NNET_ACTIVATIONS', '''NNET_ACTIVATIONS_TANH'', ''NNET_ACTIVATIONS_LOG_SIG'', ''NNET_ACTIVATIONS_ARCTAN''')
--  Note:You specify the different activation functions as strings within a single string. All quotes are single and two single quotes are used to escape a single quote in SQL statements and PL/SQL blocks.
--  The default value is NNET_ACTIVATIONS_LOG_SIG.
        '''NNET_ACTIVATIONS_RELU'''
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_HELDASIDE_MAX_FAIL 	,
-- A positive integer
-- With NNET_REGULARIZER_HELDASIDE, the training process is stopped early if the network performance on the validation data fails to improve or remains the same for NNE_HELDASIDE_MAX_FAIL epochs in a row.
-- The default value is 6.
        32
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_HELDASIDE_RATIO,
-- 0 <= numeric_expr <=1
-- Define the held ratio for the held-aside method.
-- The default value is 0.25.
        0.019991
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_HIDDEN_LAYERS,
-- A positive integer
-- Defines the topology by the number of hidden layers.
-- The default value is 1.
        7
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_ITERATIONS,
-- A positive integer
-- Specifies the maximum number of iterations in the Neural Network algorithm.
-- For the DMSSET_NN_SOLVER_LBFGS solver, the default value is 200.
-- For the DMSSET_NN_SOLVER_ADAM solver, the default value is 10000.
        60000
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_NODES_PER_LAYER,
-- A positive integer or a list of positive integers
-- Defines the topology by the number of nodes per layer. Different layers can have different numbers of nodes.
-- To specify the same number of nodes for each layer, you can provide a single value, which is then applied to each layer.
-- To specify a different number of nodes for one or more layers, provide a list of comma-separated positive integers, one for each layer. For example, '10, 20, 5' for three layers. The setting values must be consistent with the NNET_HIDDEN_LAYERS value.
-- The default number of nodes per layer is the number of attributes or 50 (if the number of attributes > 50).
        '1024,512,256,128,64,32,16'    
    );

--     INSERT INTO neural_network_settings (
--         setting_name,
--         setting_value
--     ) VALUES (
--         dbms_data_mining.NNET_REG_LAMBDA,
-- -- TO_CHAR(numeric_expr >=0)
-- -- Defines the L2 regularization parameter lambda. This can not be set together with NNET_REGULARIZER_HELDASIDE.
-- -- The default value is 1.
--         1
--     );

--     INSERT INTO neural_network_settings (
--         setting_name,
--         setting_value
--     ) VALUES (
--         dbms_data_mining.NNET_REGULARIZER,
-- -- One of the following strings:
-- --     NNET_REGULARIZER_HELDASIDE
-- --     NNET_REGULARIZER_L2
-- --     NNET_REGULARIZER_NONE
-- -- Regularization setting for Neural Network algorithm. If the total number of training rows is greater than 50000, the default is NNET_REGULARIZER_HELDASIDE. If the totl number of training rows is less than or equal to 50000, the default is NNET_REGULARIZER_NONE.
--         NNET_REGULARIZER_NONE
--     );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_TOLERANCE,
-- TO_CHAR(0< numeric_expr <1)
-- Defines the convergence tolerance setting of the Neural Network algorithm.
-- The default value is 0.000001.
        0.000000001
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_WEIGHT_LOWER_BOUND,
-- A real number
--     The setting specifies the lower bound of the region where weights are randomly initialized. NNET_WEIGHT_LOWER_BOUND and NNET_WEIGHT_UPPER_BOUND must be set together. Setting one and not setting the other raises an error. NNET_WEIGHT_LOWER_BOUND must not be greater than NNET_WEIGHT_UPPER_BOUND. The default value is –sqrt(6/(l_nodes+r_nodes)). The value of l_nodes for:
--    input layer dense attributes is (1+number of dense attributes)
--    input layer sparse attributes is number of sparse attributes
--    each hidden layer is (1+number of nodes in that hidden layer)
-- The value of r_nodes is the number of nodes in the layer that the weight is connecting to.
        -.1
    );

    INSERT INTO neural_network_settings (
        setting_name,
        setting_value
    ) VALUES (
        dbms_data_mining.NNET_WEIGHT_UPPER_BOUND,
-- A real number
-- This setting specifies the upper bound of the region where weights are initialized. It should be set in pairs with NNET_WEIGHT_LOWER_BOUND and its value must not be smaler than the value of NNET_WEIGHT_LOWER_BOUND. If not specified, the values of NNET_WEIGHT_LOWER_BOUND and NNET_WEIGHT_UPPER_BOUND are system determined.
-- The default value is sqrt(6/(l_nodes+r_nodes)). See NNET_WEIGHT_LOWER_BOUND. 
        .1
    );

    COMMIT;
END;

/

select * from neural_network_settings;

-- CREACIÓN Y ENTRENAMIENTO DE MODELOS
exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL');
--------------------------------
-- 10 MODELOS
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL0');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL1');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL2');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL3');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL4');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL5');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL6');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL7');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL8');
-- exec SYS.DBMS_DATA_MINING.DROP_MODEL('DEEP_LEARNING_MODEL9');
--------------------------------

BEGIN
   DBMS_DATA_MINING.CREATE_MODEL(
      model_name          => 'DEEP_LEARNING_MODEL',       -- regression
      mining_function     => dbms_data_mining.regression, -- classification
      data_table_name     => 'MNIST',
      case_id_column_name => 'ID',
      target_column_name  => 'RES',
      settings_table_name => 'neural_network_settings');
--------------------------------
-- 10 MODELOS
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL0',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST0',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL1',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST1',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL2',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST2',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL3',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST3',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL4',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST4',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL5',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST5',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL6',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST6',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL7',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST7',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL8',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST8',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--    DBMS_DATA_MINING.CREATE_MODEL(
--       model_name          => 'DEEP_LEARNING_MODEL9',       -- regression
--       mining_function     => dbms_data_mining.regression, -- classification
--       data_table_name     => 'MNIST9',
--       case_id_column_name => 'ID',
--       target_column_name  => 'RES',
--       settings_table_name => 'neural_network_settings');
--------------------------------
END;

/
--------------------------------

select * from all_mining_model_settings where model_name='DEEP_LEARNING_MODEL';

SELECT T.RES,
 PREDICTION (DEEP_LEARNING_MODEL5 USING *) NN_RES
FROM MNIST_TEST T where (rownum <134);


-- ERROR CALCULATION --
WITH T(ID, RES, NN_RES) AS
(SELECT ID, RES,
 PREDICTION (DEEP_LEARNING_MODEL USING *) NN_RES
FROM MNIST_TEST where rownum< 131)
select M.RES real_val, T.RES trained_val, T.NN_RES model_val, round(T.NN_RES), abs(round(T.NN_RES)-T.RES) err
from T
join MNIST_TEST M
ON M.ID = T.ID;


WITH T(ID, RES, NN_RES) AS
(SELECT ID, RES,
 PREDICTION (DEEP_LEARNING_MODEL USING *) NN_RES
FROM MNIST_TEST where rownum< 131)
select sum((T.NN_RES-M.RES)*(T.NN_RES-M.RES)) cuadr_err_total
from T
join MNIST_TEST M
ON M.ID = T.ID;


WITH T(ID, RES, NN_RES) AS
(SELECT ID, RES,
 PREDICTION (DEEP_LEARNING_MODEL USING *) NN_RES
FROM MNIST_TEST where rownum< 131)
select sum( DECODE( ABS(T.NN_RES-M.RES)>0.5, TRUE, 1, FALSE, 0 ) )/count(*)*100 "% error en test"
from T
join MNIST_TEST M
ON M.ID = T.ID;

WITH T(ID, RES, NN_RES) AS
(SELECT ID, RES,
 PREDICTION (DEEP_LEARNING_MODEL USING *) NN_RES
FROM MNIST where rownum< 131)
select sum( DECODE( ABS(T.NN_RES-M.RES)>0.5, TRUE, 1, FALSE, 0 ) )/count(*)*100 "% error en train"
from T
join MNIST M
ON M.ID = T.ID;


