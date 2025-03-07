## input (sorted based on booking and clicking probability per srch_id) data frame
## data frame in this column order:
# single srch id, prop_id, click_bool, booking_bool
maxDCG <- function (k, nbook, nclick){
	sum <-0
	for(i in 1:k){
		if(i <= nbook){
			rel <- 5
		}
		else if(i<=nclick){
			rel <- 1
		}
		else{
			rel <- 0
		}
		sum <- sum + (2^rel-1)/(log(i+1)/log(2))
	}
	return(sum)
}
snDCG <- function (data){
	sum <- 0
	for(i in 1:nrow(data)){
		rel <- data[i,3] + 4*data[i,4]
		sum <- sum + (2^rel-1)/(log(i+1)/log(2))
	}
	if (maxDCG(nrow(data), sum(data[,4]), sum(data[,3]))==0){
	  return(0)
	}
	sum <- sum/maxDCG(nrow(data), sum(data[,4]), sum(data[,3]))
	return(sum)
}
nDCG <- function (data, debug=FALSE){
	start <- 1
	dcgv <- NULL
	for(i in 2:nrow(data)){
		if(data[i,1]!=data[i-1,1] | i==nrow(data)){
			dcgv <- c(dcgv, snDCG(data[start:(i-1),]))
			start <- i
		}
	}
	if (debug==TRUE){
	  return(dcgv)
	}
	return(mean(dcgv))
}
