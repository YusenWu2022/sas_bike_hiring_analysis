```sas
/* 导入共享单车数据集 */
proc import out = bike_data
    datafile = "/home/u64038660/bike_predict/train.csv"
    dbms = csv
    replace;
    getnames = YES;
run;

/* 查看数据集的结构和内容 */
/* proc contents data=bike_data; */
/* run; */

/* proc print data=bike_data; */
/* run; */

/* 数据清洗：删除缺失值 */
/* data bike_data; */
/*   set outdata; */
/*   if cmiss(of _character_) or nmiss(of _numeric_) > 0 then delete; */
/* run; */

/* 数据标准化：将数值型变量标准化为均值为0，标准差为1 */
/* proc stdize data=bike_data reponly method=mean out=outdata; */
/*   var variables; */
/* run; */

/* 多重插补：对缺失值进行多重插补，生成5个完整的数据 */
/* proc mi data=bike_data out=outdata nimpute=5 seed=12345; */
/*   class count; */
/*   var season holiday workingday weather temp atemp humidity windspeed casual registered; */
/*   method=pmm;  */
/* run; */

/* 日期时间处理：将datetime变量拆分为日期和时间部分 */
/* data bike_data; */
/*     set bike_data; */
/*     date_part = input(scan(datetime, 1, ':'), yymmdd10.); */
/*     time_part = input(scan(datetime, 2, ':'), timeampm11.); */
/*     datetime_part = dhms(date_part, 0, 0, time_part); */
/*     date = put(datetime_part, yymmdd10.); */
/*     hour = put(datetime_part, 8.); */
/*     month = put(datetime_part, monyy5.); */
/* run; */

/* 查看处理后的数据集前100行 */
/* proc print data=bike_data(obs=100); */
/* run; */

/* 主成分分析：提取数据的主要成分，以便进行降维处理 */
/* proc princomp data=bike_data out=out_data outstat=stats; */
/*     var season holiday workingday weather temp atemp humidity windspeed casual registered count; */
/* run; */

/* 神经网络模型：使用神经网络对共享单车数量进行预测 */
/* proc nnet data=bike_data; */
/*   target count; */
/*   input season holiday workingday weather temp; */
/*   hidden 2;  */
/* run; */
/* proc neuroNet data=bike_data; */
/*   target count; */
/*   inputs season holiday workingday weather temp; */
/*   hiddens=2; */
/*   maxiter=1000; */
/*   seed=12345; */
/*   randDist=UNIFORM; */
/*   scaleInit=1; */
/*   combs=LINEAR; */
/*   targetAct=SOFTMAX; */
/*   errorFunc=ENTROPY; */
/*   std=MIDRANGE; */
/*   validTable=vldTable; */
/* run; */

/* 查看结果 */
/* proc print data=results; */
/* run; */

/* 线性回归模型：使用线性回归对共享单车数量进行预测 */
/* proc reg data=bike_data; */
/*    model count = season holiday workingday weather temp; */
/* run; */

/* 广义线性模型：使用广义线性模型对共享单车数量进行预测 */
proc glm data=bike_data;
   class season holiday workingday weather registered;
   model count = season holiday workingday weather temp humidity windspeed registered;
run;

/* 线性回归模型：再次使用线性回归对共享单车数量进行预测，并输出回归结果 */
proc reg data=bike_data outest=reg_results;
   model count = season holiday workingday weather temp humidity windspeed registered;
run;

/* 查看回归结果 */
proc print data=reg_results;
run;

/* 提取回归结果中的参数估计值 */
/* ods output ParameterEstimates=reg_results; */
/* proc glm data=bike_data; */
/*   class season holiday workingday weather; */
/*   model count = season holiday workingday weather temp humidity windspeed registered; */
/* run; */

/* 计算预测值、残差及其平方 */
proc sql;
  select season into :season from reg_results;
  select holiday into :holiday from reg_results;
  select workingday into :workingday from reg_results;
  select weather into :weather from reg_results;
  select temp into :temp from reg_results;
  select Intercept into :Intercept from reg_results;
  select humidity into :humidity from reg_results;
  select windspeed into :windspeed from reg_results;
  select registered into :registered from reg_results;
quit;
data bike_data;
  set bike_data;
  predict_count = season*&season + holiday*&holiday + workingday*&workingday + weather*&weather+ temp*&temp+&Intercept+ humidity*&humidity+windspeed*&windspeed+registered*&registered;
  residual = count - predict_count;
  residual_squared = residual**2;
run;

/* 计算残差平方的均值 */
proc means data=bike_data mean;
  var residual_squared;
run;
```
