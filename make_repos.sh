#!/bin/sh
rm -rf repos
mkdir repos
for repo in pickle-linux/*/
do
	repo_dir=${repo%*/}
	repo_dir=${repo_dir##*/}
	repo_dir=repos/$repo_dir
	mkdir $repo_dir
	for package in $repo/*/
	do
		cp $package/.build/*.sqsh $repo_dir
	done
done
