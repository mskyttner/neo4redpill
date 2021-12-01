#devtools::install_github("kth-library/kthcorpus")
library(kthcorpus)

publications <- kth_diva_pubs()





# load publication data into a RDBMS (duckdb)

library(duckdb)
library(dplyr)

con <- dbConnect(duckdb())
duckdb::duckdb_register(con, "publications", publications)

# now we can use custom SQL queries
dbGetQuery(con, "SELECT count(*) from publications")





# or we can use tidyverse APIs for data manipulation
pubs <- 
  con %>% 
  tbl("publications") %>% 
  group_by(PublicationType) %>%
  tally()

dbDisconnect(con, shutdown = TRUE)

# First convert RDBMS data in an ETL/ELT step

# kthcorpus:::neo4j_bulk_extract()

# start neo4kth container w "docker-compose up -d"

# access data using R binding

browseURL("https://github.com/neo4j-rstats/neo4r")

library(neo4r)
library(magrittr)

con <- neo4j_api$new(
  url = "http://localhost:7474", 
  user = "neo4j", 
  password = "password"
)

'MATCH (n:Author) RETURN n LIMIT 25;' %>%
  call_neo4j(con)

res <- 
  'MATCH (n:Publication) RETURN n LIMIT 25;' %>%
  call_neo4j(con, type = "graph")

