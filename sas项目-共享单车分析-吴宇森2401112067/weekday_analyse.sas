/* 导入共享单车数据集，数据文件包含日期和共享单车使用次数 */
proc import out = bike_data
    datafile = "/home/u64038660/bike_predict/count_date_dim.csv"
    dbms = csv
    replace;
    getnames = YES;
run;

/* 计算并绘制工作日共享单车使用次数的频率分布 */
/* proc freq data=bike_data; */
/*   tables weekday_no / out=freq_weekday_0; */
/* run; */
/* proc sgplot data=freq_weekday_0; */
/*   vbar weekday_no; */
/* run; */

/* 按日期对数据进行排序 */
/* proc sort data=bike_data; */
/*   by date; */
/* run; */

/* 计算并绘制每天共享单车使用次数的频率分布 */
/* proc freq data=bike_data; */
/*   tables date / out=freq_date; */
/* run; */
/* proc sgplot data=freq_date; */
/*   set bike_data */
/*   series x=date y=date_count / markers; */
/* run; */

/* 对共享单车使用次数进行时间序列分解，提取季节性成分 */
/* proc timeseries data=bike_data out=seasonal_decomp; */
/*   id DATE interval=day; */
/*   var COUNT; */
/*   season; */
/* run; */
/* proc sgplot data=seasonal_decomp; */
/*   series x=DATE y=COUNT; */
/* run; */

/* 计算每周共享单车使用次数的总和，并绘制条形图 */
/* proc sql; */
/*   create table weekly_counts as */
/*   select */
/*     weekday(DATE, 1) as WEEKDAY_NO, */
/*     sum(COUNT) as total_count */
/*   from */
/*     bike_data */
/*   group by */
/*     WEEKDAY_NO; */
/* quit; */
/* proc sgplot data=weekly_counts; */
/*   vbar WEEKDAY_NO / response=total_count; */
/*   xaxis label='Day of Week'; */
/*   yaxis label='Total Count'; */
/*   keylegend / title='Day of Week'; */
/* run; */

/* 使用ARIMA模型对共享单车使用次数进行预测 */
/* 首先识别数据的特性，然后估计模型参数，最后进行未来12天的预测 */
proc arima data=bike_data;
  identify var=COUNT;
  estimate p=0 q=4;
  forecast lead=12 id=DATE interval=day out=forecast_results;
run;

/* 使用ARIMA模型进行模型识别和参数选择 */
/* proc arima data=bike_data; */
/* identify var=COUNT nlag=8 stationrity=(adf) minic p=(0:5) q=(0:5); */
/* run; */