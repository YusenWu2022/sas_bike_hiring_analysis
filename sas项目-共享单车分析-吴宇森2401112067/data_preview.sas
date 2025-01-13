
proc import out = bike_data
    datafile = "/home/u64038660/bike_predict/train.csv"
    dbms = csv
    replace;
	getnames = YES;
run;

proc standard data=bike_data mean=0 std=1 out=std_dataset;
	var season weather temp atemp humidity windspeed casual registered count;
run;

/* proc princomp data=std_dataset out=out_data outstat=stats n=5; */
/*   var season holiday workingday weather temp atemp humidity windspeed casual registered count; */
/* run; */

proc cluster data=std_dataset outtree=tmp method=CENTROID;
  var season holiday workingday weather temp atemp humidity windspeed casual registered;
run;

proc tree data=tmp;
  tree outtree=tmp;
run;

/* proc fastclus data=std_dataset maxcluster=16 out=tmp; */
/*    var season holiday workingday weather temp atemp humidity windspeed casual registered; */
/* run; */


/* %macro find_best_k(max_clusters=20); */
/*   %local best_k max_pseudoF; */
/*   %let best_k = 1; */
/*   %let max_pseudoF = 0; */
/*   %do k = 1 %to &max_clusters; */
/*     proc fastclus data=std_dataset maxclusters=&k out=cluster_results; */
/*       var season holiday workingday weather temp atemp humidity windspeed casual registered; */
/*     run; */
/*     data cluster_results; */
/*       set cluster_results; */
/*       if _N_ = 1; */
/*     run; */
/*     proc contents data=cluster_results out=work.tmp(keep=PseudoF) ; */
/*       run; */
/*     data work.tmp; */
/*       set work.tmp; */
/*       if PseudoF > &max_pseudoF then do; */
/*         &max_pseudoF = PseudoF; */
/*         &best_k = &k; */
/*       end; */
/*     run; */
/*   %end; */
/*   %put The best number of clusters is &best_k with the highest Pseudo F value of &max_pseudoF.; */
/* %mend find_best_k; */
/*  */
/* %find_best_k(); */
