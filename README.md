[![Build Status](https://travis-ci.org/igunawardana/currency-watcher.svg?branch=master)](https://travis-ci.org/igunawardana/currency-watcher)

# Currency Watcher

This reads the currency rates from a public API and if the curent rates makes a rule true then it sends a notification to the users who are subscribed to this service. This is a pet project done to learn the Ballerina (https://ballerina.io/)  language.

## Getting Started

As mentioned this is a pet project. If you want to setup this in your local enviroment you need to get an configure a key for the fixer API, more info (https://fixer.io/)

### Prerequisites

Update the configs with the fixer API key.

## Running the tests

ballerina build currency-reader will build the currency-reader package

## Built With

This is configure to build with https://travis-ci.org/igunawardana/currency-watcher. Currently this will push a docker image to the docker hub.
