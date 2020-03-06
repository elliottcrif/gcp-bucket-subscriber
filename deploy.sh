#!/bin/bash

mkdir build

zip build/index.zip go.mod go.sum subscriber.go

pushd terraform

terraform plan && terraform apply

rm -rf build

