#!/bin/bash
#init parameters
current_dir=`pwd`    #/data/project/search
result_dir=${current_dir}/result
history_dir=${current_dir}/history
repo_list="ommb,gulommb,u31tools,rct,ommrv3,ommrv4,rs,gutems,lteems,pf"
path_list="ommb_main,gulommb,ltetools/master/u31_tools/code/,rct/rct,ommr/ommrv3,ommr/ommrv4,ems_version_tool/rs/rs,ems_version_tool/emspf/gut_ems/ems,ems_version_tool/dev,ems_version_tool/emspf/pf"
#firstly,judge parameters number
if [ $# -gt 0 ]
then
  echo "parameter number is greater 0"
else
  echo "parameter number is 0, is illegal,please input corrent parameter number again"
  exit
fi
#secondly,receive input parameter
if [ -n $1 ]
then
  content=$1
else
  echo "content is default"
  content=asia,china,America,Japan
fi
if [ -n $2 ]
then
  repos=$2
else
  echo "repos is default"
  repos=${repo_list}
fi
if [ -n $3 ]
then
  branch=$3
else
  echo "branch is default"
  branch=master
fi
if [ -n $4 ]
then
  search_type=$4
else
  echo "search_type is default"
  search_type=f
fi
if [ -n $5 ]
then
  search_model=$5
else
  echo "search_model is default"
  search_model="|"
fi
if [ -n $6 ]
then
  exclude_content=$6
else
  echo "exclude_content is default"
  exclude_content=male,jdk
fi
echo "************all parameters*********************"
echo "content is $content"
echo "repos is $repos"
echo "branch is $branch"
echo "search_type is $search_type"
echo "search_model is $search_model"
echo "exclude_content is $exclude_content"
echo "*************deal with history************************************"
if [ "`ls -A ${result_dir}`" != "" ]; then
  echo "${result_dir} is not indeed empty"
  cp -af ${result_dir}/*.txt ${history_dir}/
  rm -rf ${result_dir}/*
fi
echo "**************deal with variables*********************************"
#parse search content
if [ "$search_model" == "|" ]
then
  search_list=${search_content//,/\\|}
  #search_list=${search_list// /[:space:]}
else
  search_list=${search_content//,/ }
fi
echo ${search_list}
#keywords=`echo \"${search_list}\"`
#echo ${keywords}
search_repos=(${search_repository//,/ }) #change to list
#echo ${search_repos[@]}
#repo_len=${#search_repos[@]}
search_path=(${path_list//,/ }) #change to list
#path_len=${#search_path[@]}
count=0
DATE=`date '+%Y-%m-%d_%H-%M-%S'`
resultname="Result_${search_branch}_${DATE}.txt"
echo "your result file is ${resultname}"
for repo in ${repo_list//,/ }
do
  for s_repo in ${search_repos[@]}
  do
    if [ "$repo" == "$s_repo" ]
    then
      path_exe=${search_path[$count]}
      cd ${current_dir}/../${path_exe}
      #git checkout ${search_branch}
      path_pwd=`pwd`
      echo ${path_pwd}
      if [ "$search_type" == "f" ]; then
        if [ ! -f ${result_dir}/${resultname} ]; then
          touch ${result_dir}/${resultname}
          echo "find ${path_pwd} -type ${search_type} | xargs grep \"${search_list}\" | grep -v Binary > ${result_dir}/${resultname}"
          echo "*******************************************begin********************************************************************"
          echo "*******************************************${repo}*********************************************" > ${result_dir}/${resultname}
          find ${path_pwd} -type  ${search_type} | xargs grep "\"${search_list}\"" | grep -v Binary | grep -v -i Irant >> ${result_dir}/${resultname}   #exclude space influence
        else
          echo "find ${path_pwd} -type ${search_type} | xargs grep \"${search_list}\" | grep -v Binary >> ${result_dir}/${resultname}"
          echo "*******************************************continue********************************************************************"
          echo "*******************************************${repo}*********************************************" >> ${result_dir}/${resultname}
          find ${path_pwd} -type  ${search_type} | xargs grep "\"${search_list}\"" | grep -v Binary | grep -v -i Irant >> ${result_dir}/${resultname} 
        fi
      else
        if [ ! -f ${result_dir}/${resultname} ]; then
          touch ${result_dir}/${resultname}
          echo "find . -name \"${search_list}\" > ${result_dir}/${resultname}"
          echo "*******************************************${repo}*********************************************" > ${result_dir}/${resultname}
          find . -name "\"${search_list}\"" >> ${result_dir}/${resultname}
          echo "*******************************************begin********************************************************************"
        else
          echo "find . -name \"${search_list}\" >> ${result_dir}/${resultname}" 
          echo "*******************************************${repo}*********************************************" >> ${result_dir}/${resultname}
          find . -name "\"${search_list}\"" >> ${result_dir}/${resultname}
          echo "*******************************************continue********************************************************************"
        fi  
      fi        
    fi
  done
  ((count++))
  #echo ${count}
done
cd ${result_dir}
#show search_result
echo "*******************************************result********************************************************************"
echo "your result is :"
cat ${resultname}
echo "*******************************************result********************************************************************"
