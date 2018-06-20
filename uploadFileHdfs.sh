#set java env
export JAVA_HOME=/usr/local/jdk1.7.0_45
export JAR_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
#set hadoop env
export HADOOP_HOME=/home/hadoop/apps/hadoop-2.6.4
export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH
#目录文件存放目录
log_src_dir=/home/hadoop/logs/log/
#待上传文件存放的目录
log_toupload_dir=/home/hadoop/logs/toupload/

#日志文件上传到hdfs的根路径
hdfs_root_dir=/data/clickLog/20151226/
#打印环境变量信息
echo "envs:hadoop home :$HADOOP_HOME"		
echo "envs:java home :$JAVA_HOME"
#读取日志文件的目录，判断是否有需要上传的文件
echo "log_src_dir:"$log_src_dir
ls $log_src_dir | while read fileName
do 
	if [[ "$fileName"==access.log.* ]]; then
		date=`date +%Y_%m_%d_%H_%M_%S`
		#将文件移动到待上传目录并且重命名
		#打印信息
		echo "$log_toupload_dir"xxxxx_click_log_$fileName"$date $log_toupload_dir"xxxxx_click_log_$fileName"$date"
		mv $log_src_dir$fileName $log_toupload_dir"xxxxx_click_log_$fileName"$date
		#将待上传的文件path写到willDoing文件里
		echo $log_toupload_dir"xxxxx_click_log_$fileName"$date >> $log_toupload_dir"willDoing."$date
	fi
done
#找到列表文件
ls $log_toupload_dir | grep will | grep -v "_COPY_" | grep -v "_DONE_" | while read line
do 
	#打印信息
	echo "toupload is in file:"$line
		#将待上传文件列表willDoing改名为willDoing_COPY_
	mv $log_toupload_dir$line $log_toupload_dir$line"_COPY_"
		#读列表文件willDoing_COPY_的内容（一个一个的待上传文件名）  ,此处的line 就是列表
	cat  $log_toupload_dir$line"_COPY_" | while read line
	do 
		#打印信息
		echo "puting...$line to hdfs path.....$hdfs_root_dir"
		#上传的Hadoop HDFS
		hadoop fs -put $line $hdfs_root_dir
	done 
	mv  $log_toupload_dir$line"_COPY_" $log_toupload_dir$line"_DONE_"
done
