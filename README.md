# Docker Compose Setup for Project

## Medium Article
Explanation of this project can be accessed: [https://istywhyerlina.medium.com/etl-orchestration-be1b4dd91159] 

##Preparation
Before you can run this project using Docker Compose, make sure you have created a `.env` file with the necessary environment variables. 

Here are the steps to set up the project:

1. Create a new file named `.env` in the root directory of the project.
2. Open the `.env` file and add the following environment variables:

```
# Source
SRC_POSTGRES_DB=olist-src
SRC_POSTGRES_HOST=localhost
SRC_POSTGRES_USER=[YOUR USERNAME]
SRC_POSTGRES_PASSWORD=[YOUR PASSWORD]
SRC_POSTGRES_PORT=[YOUR PORT]

# DWH
DWH_POSTGRES_DB=olist-dwh
DWH_POSTGRES_HOST=localhost
DWH_POSTGRES_USER=[YOUR USERNAME]
DWH_POSTGRES_PASSWORD=[YOUR PASSWORD]
DWH_POSTGRES_PORT=[YOUR PORT]


# DIRECTORY
DIR_ROOT_PROJECT=
DIR_TEMP_LOG=
DIR_TEMP_DATA=                 #  <project_dir>/pipeline/temp
DIR_EXTRACT_QUERY=                    #  
DIR_LOAD_QUERY=                        #  <project_dir>/pipeline/src_query/load
DIR_TRANSFORM_QUERY=                   #  <project_dir>/pipeline/src_query/transform


```

Now you are ready to run the project using Docker Compose. Use the following command in the terminal:

```
docker-compose up -d
```

This will start the project and all its dependencies defined in the `docker-compose.yml` file.
