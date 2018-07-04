#!/bin/bash
# encoding: utf-8
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PDI_JSON_PATH=/data/polar

echo "Starting Apache2 (HTTPD)"
sudo apachectl start

echo "Starting ElasticSearch using ELASTIC_PATH=$ELASTIC_PATH"
elasticsearch -d

if [ -d "$PDI_JSON_PATH" ]; then
    echo "Using PDI JSON and loading into Elasticsearch: [http://localhost:9200]: JSON path: $PDI_JSON_PATH"
    es-import-bulk --url http://localhost:9200 --file $PDI_JSON_PATH/polar-data.json --requestTimeout 100000 --max 1000
fi

echo "Starting PDI Insight Visualizer using PDI_HOME=$PDI_HOME/insight-visualizer"
cd $PDI_HOME/insight-visualizer && grunt serve