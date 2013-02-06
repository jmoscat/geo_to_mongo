source("http://www.bioconductor.org/biocLite.R")
source("http://bioconductor.org/biocLite.R")
biocLite("GEOquery")
library(Biobase)
library(GEOquery)
library(RMongo)
library(rjson)

#Parsing and storing in Mongodb all expression levels of NBR1, SQSTM1, PRKCI, PAWR from 557 liver samples (GSE25097).




#Initialize Mongo

mongo <- mongoDbConnect("liver", "ds051007.mongolab.com", 51007)
authenticated <- dbAuthenticate(mongo, "jorgemoscat", "*********")


#Get Raw
#gset <- getGEO("GSE25097", GSEMatrix=FALSE)

for (i in 1:558){
	
	id <-  Meta(GSMList(gset)[[i]])$geo_accession
	type <- Meta(GSMList(gset)[[i]])$source_name_ch1
	#as.numeric(Table(GSMList(gset)[[1]])[Table(GSMList(gset)[[1]])[,1] == "100157461_TGI_at",][1,2])
	
	probe_100157461_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100157461_TGI_at",][1,2])
	probe_100121685_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100121685_TGI_at",][1,2])
	
	probe_100143556_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100143556_TGI_at",][1,2])

	probe_100126268_TGI_at  <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100126268_TGI_at",][1,2])
	probe_100129651_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100129651_TGI_at",][1,2])
	
	probe_100147338_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100147338_TGI_at",][1,2])
	probe_100131354_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100131354_TGI_at",][1,2])
	probe_100161874_TGI_at <- as.numeric(Table(GSMList(gset)[[i]])[Table(GSMList(gset)[[i]])[,1] == "100161874_TGI_at",][1,2])
	
	
	
	
	
	entry <- list ( SAMPLE_ID = id, PATIENT_TYPE = type, Info = "Null", EXPRS = list( 
	NBR1 = list( list(Probe_id = "100157461_TGI_at", Exprs = probe_100157461_TGI_at), list(Probe_id = "100121685_TGI_at", Exprs = probe_100121685_TGI_at)),
	SQSTM1 = list(Probe_id = "100143556_TGI_at", Exprs = probe_100143556_TGI_at), 
	PRKCI = list( list(Probe_id = "100126268_TGI_at", Exprs = probe_100126268_TGI_at), list(Probe_id = "100129651_TGI_at", Exprs = probe_100129651_TGI_at)),
	PAWR = list( list(Probe_id = "100147338_TGI_at", Exprs = probe_100147338_TGI_at),list(Probe_id = "100131354_TGI_at",  Exprs = probe_100131354_TGI_at),list(Probe_id = "100161874_TGI_at", Exprs = probe_100161874_TGI_at))))
	
	
	json <- toJSON( entry)
	
	if (dbInsertDocument(mongo, "GSE25097", json) == "ok"){	print(paste("success: ",id )) }
	else {	print(paste("!!!FAILED!!!: ",id )) }
	
}
