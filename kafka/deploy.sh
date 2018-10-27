file1="kafka/docker-compose.yml"
file2="docker-compose.yml"

if [ -f "$file1" ]; then 
    docker-compose -f "$file1" up -d
    exit 0
fi 

if [ -f "$file2" ]; then 
    docker-compose -f "$file2" up -d
    exit 0
fi 