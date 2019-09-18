#!/bin/bash

current_dir=`pwd`    #/data/project/search
result_dir=${current_dir}/result
history_dir=${current_dir}/history
repo_list="ommb,gulommb,u31tools,rct,ommrv3,ommrv4,rs,gutems,lteems,pf"
path_list="ommb_main,gulommb,ltetools/master/u31_tools/code/,rct/rct,ommr/ommrv3,ommr/ommrv4,ems_version_tool/rs/rs,ems_version_tool/emspf/gut_ems/ems,ems_version_tool/dev,ems_version_tool/emspf/pf"

if [ -n "$1" ]
then
  search_content=$1
else
  echo "please input search content"
  exit 1
fi

if [ -n "$2" ]
then
  search_repository=$2
else
  search_repository=${repo_list}  # all repositories
fi

if [ -n "$3" ]
then
  search_branch=$3
else
  search_branch=master
fi

if [ -n "$4" ]
then
  search_type=$4
else
  search_type="none"     #empty
fi

if [ -n "$5" ]
then
  search_model=$5
else
  search_model="|"     #or
fi

if [ -n "$6" ]
then
  file_type=$6
fi

if [ "`ls -A ${result_dir}`" != "" ]; then
  echo "${result_dir} is not indeed empty"
  cp -af ${result_dir}/*.txt ${history_dir}/
  rm -rf ${result_dir}/*
fi

#echo ${search_type}
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
resultname="Result_${DATE}.txt"
echo "your result file is ${resultname}"
for repo in ${repo_list//,/ }
do
  for s_repo in ${search_repos[@]}
  do
    if [ "$repo" == "$s_repo" ]
    then
      path_exe=${search_path[$count]}
      cd ${current_dir}/../${path_exe}
      git pull
      git reset --hard origin/${search_branch}
      git clean -xdf
      git checkout ${search_branch}
      git pull
      path_pwd=`pwd`
      echo ${path_pwd}
      if [ "$search_type" == "f" ]; then
        if [ ! -f ${result_dir}/${resultname} ]; then
          touch ${result_dir}/${resultname}
          if [ -n "$file_type" ]
          then
            echo "find ${path_pwd} -name *.${file_type} | xargs grep \"${search_list}\" | grep -v Binary > ${result_dir}/${resultname}"
            echo "*******************************************begin********************************************************************"
            echo "*******************************************${repo}*********************************************" > ${result_dir}/${resultname}
            find ${path_pwd} -name  "*.${file_type}" | xargs grep "\"${search_list}\"" | grep -v Binary >> ${result_dir}/${resultname}
          else
            echo "find ${path_pwd} -name  *.java | xargs grep \"${search_list}\" | grep -v Binary > ${result_dir}/${resultname}"
            echo "*******************************************begin********************************************************************"
            echo "*******************************************${repo}*********************************************" > ${result_dir}/${resultname}
            find ${path_pwd} -name  "*.java" | xargs grep ${search_list} | grep -v Binary >> ${result_dir}/${resultname}
          fi
        else
          if [ -n "$file_type" ]
          then
            echo "find ${path_pwd} -name *.${file_type} | xargs grep \"${search_list}\" | grep -v Binary >> ${result_dir}/${resultname}"
            echo "*******************************************continue********************************************************************"
            echo "*******************************************${repo}*********************************************" >> ${result_dir}/${resultname}
            find ${path_pwd} -name  "*.${file_type}" | xargs grep "\"${search_list}\"" | grep -v Binary >> ${result_dir}/${resultname}
          else
            echo "find ${path_pwd} -name  *.java | xargs grep \"${search_list}\" | grep -v Binary >> ${result_dir}/${resultname}"
            echo "*******************************************continue********************************************************************"
            echo "*******************************************${repo}*********************************************" >> ${result_dir}/${resultname}
            find ${path_pwd} -name  "*.java" | xargs grep ${search_list} | grep -v Binary >> ${result_dir}/${resultname}
          fi
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
