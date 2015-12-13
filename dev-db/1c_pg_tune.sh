#!/bin/bash
 
if [ -z $1 ]; then
    PG_CNF="/etc/postgresql-9.2/postgresql.conf"
else
    PG_CNF=$1
fi
 
# Cheking if all needed programs are installed
for PROGZ in awk bc sed; do
 WPROGZ=`which $PROGZ`
 if test $? -ne 0; then
    # Error message is printed by 'which'
    exit 1
 fi
done
 
# Get RAM size
MEM=`awk '{if(/MemTotal/){if($3=="kB"){$2/=1024;$3="MB"}; printf("%d\n",$2 + 0.5)}}' /proc/meminfo`
 
# 1/4 RAM
MAINTENANCE_WORK_MEM=`echo $MEM/4 | bc`MB
# 1/20 RAM
WORK_MEM=`echo $MEM/20 | bc`MB
# 1/8 RAM
SHARED_BUFFERS=`echo $MEM/8 | bc`MB
# 1/4 RAM
EFFECTIVE_CACHE_SIZE=`echo $MEM/4 | bc`MB
COMMIT_DELAY="100"
COMMIT_SIBLINGS="10"
WAL_SYNC_METHOD="fdatasync"
AUTOVACUUM="on"
AUTOVACUUM_VACUUM_THRESHOLD="1800"
MAX_LOCKS_PER_TRANSACTION="250"
 
# Раскомментируем параметры
sed -i "s/#maintenance_work_mem/maintenance_work_mem/g"                            $PG_CNF
sed -i "s/#work_mem/work_mem/g"                                                    $PG_CNF
sed -i "s/#shared_buffers/shared_buffers/g"                                        $PG_CNF
sed -i "s/#effective_cache_size/effective_cache_size/g"                            $PG_CNF
sed -i "s/#commit_delay/commit_delay/g"                                            $PG_CNF
sed -i "s/#commit_siblings/commit_siblings/g"                                      $PG_CNF
sed -i "s/#wal_sync_method/wal_sync_method/g"                                      $PG_CNF
sed -i "s/#autovacuum/autovacuum/g"                                                $PG_CNF
sed -i "s/#autovacuum_vacuum_threshold/autovacuum_vacuum_threshold/g"              $PG_CNF
sed -i "s/#max_locks_per_transaction/max_locks_per_transaction/g"                  $PG_CNF
 
# Меняем параметры в конф. файле PostgreSQL
sed -i "s/^\(maintenance_work_mem = \).*$/\1$MAINTENANCE_WORK_MEM/g"               $PG_CNF
sed -i "s/^\(work_mem = \).*$/\1$WORK_MEM/g"                                       $PG_CNF
sed -i "s/^\(shared_buffers = \).*$/\1$SHARED_BUFFERS/g"                           $PG_CNF
sed -i "s/^\(effective_cache_size = \).*$/\1$EFFECTIVE_CACHE_SIZE/g"               $PG_CNF
sed -i "s/^\(commit_delay = \).*$/\1$COMMIT_DELAY/g"                               $PG_CNF
sed -i "s/^\(commit_siblings = \).*$/\1$COMMIT_SIBLINGS/g"                         $PG_CNF
sed -i "s/^\(wal_sync_method = \).*$/\1$WAL_SYNC_METHOD/g"                         $PG_CNF
sed -i "s/^\(autovacuum = \).*$/\1$AUTOVACUUM/g"                                   $PG_CNF
sed -i "s/^\(autovacuum_vacuum_threshold = \).*$/\1$AUTOVACUUM_VACUUM_THRESHOLD/g" $PG_CNF
sed -i "s/^\(max_locks_per_transaction = \).*$/\1$MAX_LOCKS_PER_TRANSACTION/g"     $PG_CNF
