/* 导入共享单车数据集 */
proc import out = bike_data
    datafile = "/home/u64038660/bike_predict/train.csv"
    dbms = csv
    replace;
	getnames = YES;
run;

/* 处理缺失值 */
/* proc mi data=bike_data out=bike_data_output; */
/*    mcmc; */
/*    var count season; */
/* run; */

/* 对数据进行排序并去除重复记录 */
/* proc sort data=bike_data out=bike_data_sorted nodupkey; */
/*   by datetime; */
/* run; */

/* 查看数据集的前100条记录 */
/* proc print data=bike_data(obs=100); */
/* run; */

/* 计算共享单车数量的统计量，如样本量、缺失值数量、均值、中位数、最大值和最小值*/
/* proc means data=bike_data N NMISS mean median max min; */
/*   var count; */
/*   output out=means_results */
/*   N=N */
/*   NMISS=NMISS */
/*   mean=mean */
/*   median=median */
/*   max=max */
/*   min=min; */
/* run; */

/* 绘制共享单车数量与其他变量之间的散点图矩阵，以初步探索变量间的关系 */
/* proc sgscatter data=bike_data; */
/*   matrix count season holiday humidity windspeed temp ; */
/* run; */

/* 计算共享单车数据集中相关变量之间的相关系数矩阵 */
proc corr data=bike_data out=bike_corr;
  var temp atemp casual registered humidity windspeed count;
run;

/* 对相关系数矩阵进行转置 */
/* proc transpose data=bike_corr out=bike_corr_transposed; */
/* run; */

/* 打印转置后的相关系数矩阵 */
/* proc print data=bike_corr_transposed; */
/* run; */

/* 将相关系数矩阵转换为长格式，以便绘制热力图 */
/* data bike_corr_transposed; */
/*   set bike_corr_transposed; */
/*   array corr[7] col1-col7; */
/*   do i = 1 to 7; */
/*     do j = 1 to 7; */
/*       Row = i; */
/*       Col = j; */
/*       Value = corr[j]; */
/*       output out=bike_corr_long; */
/*     end; */
/*   return; */
/* run; */

/* 绘制相关系数矩阵的热力图 */
/* proc sgplot data=bike_corr_long; */
/*   heatmap data=bike_corr_long / x=Col y=Row colorresponse=Value; */
/* run; */

/* 将相关系数矩阵转换为长格式，并为非对角线元素生成相关系数名称 */
/* data bike_corr_transposed; */
/*   set bike_corr_transposed; */
/*   array corr[7] temp atemp casual registered humidity windspeed count; */
/*   do i = 1 to 7; */
/*     do j = 1 to 7; */
/*       if i ^= j then do; */
/*         corr_name = cats('corr_', vname(corr[i]), '_', vname(corr[j])); */
/*         output out=bike_corr_long; */
/*       end; */
/*     end; */
/*   return;  */
/* run; */

/* 绘制相关系数矩阵的热力图 */
/* proc sgplot data=bike_corr_long noautolegend; */
/*   heatmapparm x=_N_ y=_N_ colorresponse=corr / colormodel=(blue red); */
/*   xaxis display=(nolabel noticks); */
/*   yaxis display=(nolabel noticks); */
/* run; */

/* 绘制共享单车数量按季节分类的箱线图，以观察不同季节的共享单车使用情况 */
/* proc sgplot data=bike_data; */
/*   vbox count / category=season; */
/*   yaxis label='Value'; */
/* run; */

/* 绘制共享单车数量和天气情况随时间变化的折线图，以分析时间趋势和天气对共享单车使用的影响 */
/* proc sgplot data=bike_data; */
/*   series x=datetime y=count / markers markerattrs=(symbol=circlefilled size=7) lineattrs=(pattern=solid color=red); */
/*   series x=datetime y=weather / markers markerattrs=(symbol=circlefilled size=7) lineattrs=(pattern=solid color=blue); */
/*   xaxis label='Date'; */
/*   yaxis label='Value'; */
/* run; */