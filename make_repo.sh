#!/bin/sh
rm -rf repo
mkdir repo

for package in pickle-linux/*
do
	cp $package/.stage4/*.sqsh repo
done
