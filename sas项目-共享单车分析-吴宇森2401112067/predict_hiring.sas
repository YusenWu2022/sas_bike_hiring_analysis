/* 导入共享单车数据集，将其存储在名为bike_data的SAS数据集中 */
proc import out = bike_data
    datafile = "/home/u64038660/bike_predict/train.csv"
    dbms = csv
    replace;
	getnames = YES;
run;

/* 使用逐步回归方法建立共享单车数量与多个自变量之间的线性回归模型，以自动选择对因变量有显著影响的自变量 */
proc reg data=bike_data;
  model count=season holiday workingday weather temp atemp humidity windspeed casual registered / selection=stepwise;
run;

/* 使用LASSO回归方法建立共享单车数量与部分自变量之间的回归模型，并输出模型参数估计结果 */
/* proc hplm data=bike_data outest=lasso_results; */
/*   model count = season holiday workingday weather / selection=lasso; */
/* run; */

/* 建立共享单车数量与部分自变量之间的线性回归模型，并计算残差平方和 */
/* proc reg data=bike_data; */
/*   model count = season holiday workingday weather; */
/*   output out=results */
/*     R=R */
/* run; */
/*  */
/* data results; */
/*   set results; */
/*   TotalRSS = sum(of R); */
/* run; */
/*  */
/* proc means data=results N NMISS mean; */
/*   var TotalRSS; */
/*   output out=means_results */
/*     N=N */
/*     NMISS=NMISS */
/*     MEAN=MEAN */
/*     / autoname; */
/* run; */

/* 使用逐步回归方法建立共享单车数量与部分自变量之间的线性回归模型 */
/* proc glmselect data=bike_data; */
/*   model count = season holiday / selection=stepwise; */
/* run; */