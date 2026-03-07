#!/bin/bash
awslocal logs create-log-group --log-group-name producto-log-group
awslocal logs create-log-group --log-group-name ordenes-log-group
awslocal logs create-log-group --log-group-name pagos-log-group
awslocal logs create-log-group --log-group-name api-gateway-log-group
